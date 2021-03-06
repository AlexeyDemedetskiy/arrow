/// This structure can act as a view to original token stream.
/// It can navigate in any direction, restore state or pointer and provide some capabilities to access current elements
public struct Parser {
    /// single point of change if I need to go to `ArraySlice<Token>` for example.
    public typealias Collection = [Token]
    public typealias Index = Collection.Index
    
    /// Stream can be created with a collection. Even empty collection will work
    public init(stream: Collection) {
        self.tokens = stream
        self.index = stream.startIndex
    }
    
    private let tokens: Collection
    private var index: Index
    
    /// Current token can be  nil in empty collection or if all items are already consumed
    var current: Token? { tokens.indices.contains(index) ? tokens[index] : nil }
    
    /// Consumes current token and moves to the next one.
    mutating func consume() {
        index = index.advanced(by: 1)
    }
    
    mutating func rollback() {
        index = index.advanced(by: -1)
    }
    
    struct State {
        fileprivate let stream: Parser
    }
    
    func store() -> State {
        State(stream: self)
    }
    
    mutating func restore(state: State) {
        self = state.stream
    }
}
