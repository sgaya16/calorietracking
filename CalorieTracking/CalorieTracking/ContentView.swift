//
//  ContentView.swift
//  calorie tracker
//
//  Created by Sara Gaya on 5/31/23.
//

import SwiftUI
import CoreData
import Foundation
import ConfettiSwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var caloricInfo: FetchedResults<CaloricInfo>
    
    let calorieIntakeGoal: Int64 = 1200
    @State private var caloricEntity: CaloricInfo?
    @State private var calorieInput: Int64 = 0
    @State var caloriePercentage: CGFloat = 0
    @State var totalCalories: Int64 = 0
    @State private var updateBar = false
    @State private var triggerConfetti = 0
    @State private var showErrorAlert = false
    
    init() {
        let timestamp = Date()
        let startDate = Calendar.current.startOfDay(for: timestamp)
        
        _caloricInfo = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CaloricInfo.timestamp, ascending: false)], predicate: NSPredicate(format: "timestamp <= %@ AND timestamp >= %@", timestamp as CVarArg, startDate as CVarArg))
        
        caloricEntity = caloricInfo.first
        
        totalCalories = caloricEntity?.totalCaloricIntake ?? 0
        setCaloriePercentage()
    }
    
    var body: some View {
        
            VStack {
                Text("Total Calories: \(totalCalories)")
                    .font(.title)
                
                ProgressBar(progressPercent: $caloriePercentage)
                    .animation(.spring(), value: updateBar)
                    .confettiCannon(counter: $triggerConfetti, num: 60, rainHeight: 700, repetitions: 1)
                
               Divider()
                
                HStack(alignment: .center) {
                    Text("Enter Calories: ")
                    
                    GeometryReader { geometry in
                        //input text field
                        TextField("Enter calories consumed", value: $calorieInput, format: .number)
                            .onSubmit {
                                setTotalCalories()
                                setCaloriePercentage()
                                updateBar.toggle()
                            }
                            .textFieldStyle(.roundedBorder)
                            .alert(isPresented: $showErrorAlert) {
                                Alert(
                                    title: Text("Input Error"),
                                    message: Text("Total calorie intake can't be negative.")
                                )
                            }
                    }
                    .frame(width: 80, height: 30)
                }
                .padding()
  
            }
           // .frame(minHeight: 500)
    }
    
    //add a log that shows cals consumed vs. burned based on input for that day!
    
    func setTotalCalories() {
        //if total calories is < 0, send error message
        if ((calorieInput + totalCalories) < 0) {
            print("if statement entered")
            showErrorAlert = true
            return
        }
        totalCalories += calorieInput
        if(entityExists(id: caloricEntity?.id ?? UUID())) {
            updateEntity(caloricInfo: (caloricInfo.first)!)
        }
        else {
            addEntity()
        }
        //triggers confetti cannon if cals are >= 1000 (min daily intake)
        checkConfettiTrigger(calories: totalCalories)
    }
    
    func setCaloriePercentage() {
        caloriePercentage = CGFloat(totalCalories) / CGFloat(calorieIntakeGoal)
    }
    
    func checkConfettiTrigger(calories: Int64) {
        if (calories >= 1000) {
            triggerConfetti += 1
        }
    }
    
    func addEntity() {
        print("add entity entered")
        let caloricInfoEntity = CaloricInfo(context: viewContext)
        caloricInfoEntity.id = UUID()
        caloricInfoEntity.timestamp = Date()
        caloricInfoEntity.caloricGoal = calorieIntakeGoal
        caloricInfoEntity.totalCaloricIntake = totalCalories
        
        do {
            try viewContext.save()
            print("data successfully added!")
            caloricEntity = caloricInfoEntity
        } catch {
            print("unable to save data: \(error)")
        }
        
    }
    
    func updateEntity(caloricInfo: CaloricInfo) {
        caloricInfo.totalCaloricIntake = totalCalories
        caloricInfo.caloricGoal = calorieIntakeGoal
        
        do {
            try viewContext.save()
            print("data successfully updated!")
        } catch {
            print("unable to save data: \(error)")
        }
    }
    
    func entityExists(id: UUID = UUID()) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaloricInfo")
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as NSUUID)

        var entitiesCount = 0

        do {
            entitiesCount = try viewContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return entitiesCount > 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//caloriePercentage: 0.5)
    }
}
