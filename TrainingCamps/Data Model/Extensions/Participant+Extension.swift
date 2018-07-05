//
//  Participant+Extension.swift
//  TrainingCamps
//
//  Created by Steven Lord on 06/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Foundation

extension Participant{
    
    @objc dynamic var campsAttended: Int{return campParticipations?.count ?? 0}
    @objc dynamic var noCampsAttended: Bool { return campsAttended == 0}
    
    
    @objc dynamic var displayName: String{
        var result: String = firstName ?? ""
        result += " " + (surname ?? "")
        return result
    }
    
    @objc dynamic var surnameFirstName: String{
        var result: String = surname ?? ""
        result += firstName ?? ""
        return result
    }
    
    @objc dynamic var firstCampDate: Date?{
        if let camps = campParticipations?.allObjects as? [CampParticipant]{
            let sorted = camps.sorted(by: {$0.camp!.campStart! < $1.camp!.campStart!})
            if sorted.count > 0{
                return sorted[0].camp?.campStart
            }
        }
        return nil
    }
    
    func participantDaysArray() -> [ParticipantDay]{
        var result: [ParticipantDay] = []
        for cp in campParticipationsArray(){
            result.append(contentsOf: cp.getDays())
        }
        
        return result
    }
    
    private func campParticipationsArray() -> [CampParticipant]{
        return campParticipations?.allObjects as? [CampParticipant] ?? []
    }
    
    
    

}
