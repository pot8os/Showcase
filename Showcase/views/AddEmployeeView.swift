//
//  AddEmployeeView.swift
//  Showcase
//
//  Created by So on 2021/01/14.
//

import SwiftUI
import CoreData

struct AddEmployeeView: View {

  @State private var name = ""
  @State private var selectedIconIndex = 0
  private let iconList = ["😀", "😆", "🤪", "😎", "🤩", "😡"]
  @State private var selectedDeptIndex = 0
  private let departmentList = ["CxO", "Engineering", "Sales", "Finance", "Legal", "HR"]

  @Environment(\.managedObjectContext) private var moc
  @State private var showingAlert = false

  var body: some View {
    VStack {
      Text("Enter employee name")
        .padding()
      TextField("Employee name", text: $name)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      Text("Select face icon")
        .padding()
      Picker("Select Department", selection: $selectedIconIndex) {
        ForEach(0..<iconList.count) {
          Text(iconList[$0])
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
      Text("Select Department")
        .padding()
      Picker("Select Department", selection: $selectedDeptIndex) {
        ForEach(0..<departmentList.count) {
          Text(departmentList[$0])
        }
      }
      Button("Save") {
        guard !name.isEmpty else { return }
        let employee = Employee(context: moc)
        employee.name = name
        employee.icon = iconList[selectedIconIndex]
        employee.department = departmentList[selectedDeptIndex]
        do {
          try moc.save()
          showingAlert = true
        } catch {
          debugPrint(error)
        }
      }
      .padding()
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Done!"), message: Text("Saved `\(name)`"), dismissButton: nil)
      }
    }
    .padding()
  }
}

struct AddEmployeeView_Previews: PreviewProvider {
  static var previews: some View {
    AddEmployeeView()
  }
}
