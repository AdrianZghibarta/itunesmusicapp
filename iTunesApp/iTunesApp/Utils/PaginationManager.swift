//
//  PaginationManager.swift
//  iTunesApp
//
//  Created by Adrian Zghibarta on 12/21/15.
//  Copyright © 2015 Adrian Zghibarta. All rights reserved.
//

import UIKit

/// Basic functionality for pagination
class PaginationManager: NSObject {
    
    private var maximumNumberOfObjects = 200
    private var itemsPerPage = 10
    private var actualPage = 0
    private var isPaginationEnd = false
    /// Closure to handle the next page operations
    var nextPageHandler: ((newPageNumber: Int, actualItemsNumber: Int) -> ())?
    /// Closure to handle the end of pages
    var endPaginationHandler: (() -> ())?
    
    /**
     Initialize a Pagination Manager Structure with maximum number of pages and items per page
     
     - parameter maxNumberOfObject: Maximum number of objects ot display
     - parameter itemsPerPage:      Items per page to display
     
     - returns: PaginationManager Structure
     */
    init(maxNumberOfObject: Int, itemsPerPage: Int){
        self.maximumNumberOfObjects = maxNumberOfObject
        self.itemsPerPage = itemsPerPage
        self.actualPage = 0
    }
    
    /**
     Reset The actual Page to 0
     */
    func resetPages() {
        actualPage = 0
        isPaginationEnd = false
    }
    
    
    /**
     Process the next page events
     */
    func nextPage() {
        actualPage++
        self.isPaginationEnd = !(actualPage * itemsPerPage <= maximumNumberOfObjects)
        if  !self.isPaginationEnd {
            if let handler = self.nextPageHandler {
                handler(newPageNumber: actualPage, actualItemsNumber: actualPage * itemsPerPage)
            }
        }
        else {
        }
    }
    
    /**
     Permet to see if the last page was displayed
     
     - returns: Bool value - if the last page was displayied
     */
    func hasFinishPagination() -> Bool {
        return self.isPaginationEnd
    }
}
