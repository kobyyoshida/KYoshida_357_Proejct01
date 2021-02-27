import Cocoa
import Foundation

var str = "Hello, playground"

var passwords: [String: String] = [:]

let passphrase = "chapman123"


func newUser(){
    checkPassphrase()
    var strShift = ""
    print("Enter new name: ")
    var newUser = readLine()
    print("Enter new password: ")
    var newPass = readLine()
    var encodedPassword = newPass! + passphrase
    encodedPassword = String(encodedPassword.reversed())
    for letter in encodedPassword{
        strShift += String(encode(l: letter, trans: 27))
    }
    passwords[newUser!] = strShift
    print("New user/pass created.")
    fileWrite()
    homePage()
}

func deleteUser(){
    print("Enter the name of the user you would like to delete: ")
    var delUser = readLine()
    for (user,_) in passwords{
        if user == delUser{
            passwords[user] = nil
            print("User has been deleted.")
            fileWrite()
            homePage()
        }
        else{
            print("User does not exist.")
            homePage()
        }
    }
        
}

func printAllKeys(){
    for (key,_) in passwords{
        print(key)
    }
    homePage()
}

func viewSingleKey(){
    print("Enter the name of the key:")
    let keyName = readLine()
    var strShift = ""
    for (key,_) in passwords{
        //print("KEY: ",key)
        if (key == keyName){
            print("Enter your passphrase: ")
            let pass = readLine()
            if (pass == passphrase){
                var val = passwords[key]
                val = String(val!.reversed())
                for letter in val!{
                    strShift += String(decode(l: letter, trans: 27))
                }
                print("Password: ",strShift)
            }
        }
    }
    homePage()
}


func checkPassphrase(){
    print("Passphrase: ")
    let input = readLine()
    if (input == passphrase) {
        print("Success")
    }
    else{
        print("Incorrect passphrase.")
        homePage()
    }
}

func homePage(){
    print("""
            Enter the number of the option you would like to execute:
            1. Add new password
            2. Delete Password
            3. View all keys
            4. View a password
            5. Exit
        """)
    var reply = readLine()
    if (reply == "1"){
        newUser()
    }
    else if (reply == "2"){
        deleteUser()
    }
    else if (reply == "3"){
        printAllKeys()
    }
    else if (reply == "4"){
        viewSingleKey()
    }
    else if (reply == "5"){
        fileWrite()
        print("Exiting.")
        return
    }
    else if (reply == "8"){
        print(passwords)
    }
    else {
        print("Not a valid option.")
        homePage()
    }
}



func main(){
    fileRead()
    homePage()
}

func fileWrite(){
    do {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mybadpasswords.json")
        
        try JSONSerialization.data(withJSONObject: passwords).write(to: fileURL)
    }
    catch
    {
        print(error)
    }
}

func fileRead(){
    do{
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mybadpasswords.json")
        
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        passwords = json!
    }
    catch{
        print(error)
    }
}

func encode(l: Character, trans:Int) -> Character{
    if let ascii = l.asciiValue
    {
        var outputInt = ascii
        if (ascii >= 97 && ascii <= 122){
            outputInt = ((ascii-97+UInt8(trans))%26)+97
        }
        else if (ascii >= 65 && ascii <= 90){
            outputInt = ((ascii-65+UInt8(trans))%26)+65
        }
        return Character(UnicodeScalar(outputInt))
    }
    return Character("")
}

func decode(l: Character, trans:Int) -> Character{
    if let ascii = l.asciiValue
    {
        var outputInt = ascii
        if (ascii >= 97 && ascii <= 122){
            outputInt = ((ascii-97+UInt8(trans))%26)+95
        }
        else if (ascii >= 65 && ascii <= 90){
            outputInt = ((ascii-65+UInt8(trans))%26)+63
        }
        return Character(UnicodeScalar(outputInt))
    }
    return Character("")
}

main()


