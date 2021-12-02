// Day 21
let inputList: [[String]] = Day21Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap { $0.components(separatedBy: " (") }

let parsedInput: [(foods: [String], allergens: [String])] = inputList.map {
    let foods = $0[0].components(separatedBy: " ")
    // dropLast to remove closing paren, dropFirst 9 to remove "contains"
    let alergens = Array($0[1].dropLast().dropFirst(9).components(separatedBy: ", "))
    return (foods, alergens)
}

var potentialAllergens: [String:Set<String>] = [:]
parsedInput.forEach { entry in
    entry.allergens.forEach { allergen in
        var newSet = Set(entry.foods)
        if let currentSet = potentialAllergens[allergen] {
            newSet = newSet.intersection(currentSet)
        }
        potentialAllergens[allergen] = newSet
    }
}

// Part 1
measure("Part 1") {
    let setOfAllPotentialFoodsCausingAllergens = potentialAllergens.values.reduce(Set<String>()) { existingSet, newSet in
        return existingSet.union(newSet)
    } 

    let arrayOfAllFoods = parsedInput.reduce([]) {
        return $0 + $1.foods
    }
    
    let notPossiblyAllergens = arrayOfAllFoods.filter {
        !setOfAllPotentialFoodsCausingAllergens.contains($0)
    }
    print("Part 1 answer is: \(notPossiblyAllergens.count)")
    
}

// Part 2
measure("Part 2") {
    let sortedAllergenList = potentialAllergens.sorted {
        $0.value.count < $1.value.count
    }
    var canonicalList: [String:String] = [:]
    var skippedEntries: [String] = []
    repeat {
        skippedEntries = []
        let filteredAllergenList = sortedAllergenList.filter { !canonicalList.keys.contains($0.key) }
        filteredAllergenList.forEach { allergenEntry in
            // Filter out already assigned ingredients
            let filteredFoods = allergenEntry.value.filter {
                !canonicalList.values.contains($0)
            }
            if filteredFoods.count == 1 {
                canonicalList[allergenEntry.key] = filteredFoods.first
            } else {
                skippedEntries.append(allergenEntry.key)
            }
        }
    } while skippedEntries.count > 0
    
    let sortedList = canonicalList.sorted { $0.key < $1.key }.reduce("") { $0.count > 0 ? "\($0),\($1.value)" : $1.value }
    print("Part 2 answer is: \(sortedList)")
}

