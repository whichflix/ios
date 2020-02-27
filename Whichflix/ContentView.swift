import SwiftUI

struct ContentView: View {
    @ObservedObject var observed = Observer()

    var body: some View {
        NavigationView{
            List(observed.elections){ i in
                HStack{Text(i.title)}
                }.navigationBarItems(
                  trailing: Button(action: addEvent, label: { Text("Add") }))
            .navigationBarTitle("Events")
        }
    }

    func addEvent(){
        observed.getElections()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
