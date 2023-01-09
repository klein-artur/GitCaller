//
//  CommandCheckout.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

import Foundation

public final class CommandCheckout: Command, HasLowercaseBParameter, HasBranchnameParameter, HasTrackParameter
{
    public override var command: String {
        "checkout"
    }
}

extension Git {
    public var checkout: CommandCheckout {
        return CommandCheckout(preceeding: self)
    }
}
