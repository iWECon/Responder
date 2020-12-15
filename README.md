# Responder

A Responder Chain tools.


## Custome

eg: IGListKit
```
import Responder
import IGListKit

extension ListSectionController: Responder {
    public var nextResponder: Responder? {
        get {
            objc_getAssociatedObject(self, &ResponderKeys.nextResponder) as? Responder
        }
        set {
            objc_setAssociatedObject(self, &ResponderKeys.nextResponder, newValue,  .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
```
