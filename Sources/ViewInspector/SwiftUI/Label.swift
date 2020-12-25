import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public extension ViewType {
    
    struct Label: KnownViewType {
        public static let typePrefix: String = "Label"
    }
}

// MARK: - Extraction from SingleViewContent parent

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public extension InspectableView where View: SingleViewContent {
    
    func label() throws -> InspectableView<ViewType.Label> {
        return try .init(try child(), parent: self)
    }
}

// MARK: - Extraction from MultipleViewContent parent

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public extension InspectableView where View: MultipleViewContent {
    
    func label(_ index: Int) throws -> InspectableView<ViewType.Label> {
        return try .init(try child(at: index), parent: self, index: index)
    }
}

// MARK: - Non Standard Children

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
// MARK: - Non Standard Children

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension ViewType.Label: SupplementaryChildren {
    static func supplementaryChildren(_ content: Content) throws -> LazyGroup<Content> {
        return .init(count: 2) { index -> Content in
            let label = index == 0 ? "title" : "icon"
            let child = try Inspector.attribute(label: label, value: content.view)
            return try Inspector.unwrap(content: Content(child))
        }
    }
}

// MARK: - Custom Attributes

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public extension InspectableView where View == ViewType.Label {
    
    func title() throws -> InspectableView<ViewType.ClassifiedView> {
        let label = try View.supplementaryChildren(content).element(at: 0)
        return try .init(label, parent: self)
    }
    
    func icon() throws -> InspectableView<ViewType.ClassifiedView> {
        let label = try View.supplementaryChildren(content).element(at: 1)
        return try .init(label, parent: self)
    }
}

// MARK: - Global View Modifiers

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public extension InspectableView {

    func labelStyle() throws -> Any {
        let modifier = try self.modifier({ modifier -> Bool in
            return modifier.modifierType.hasPrefix("LabelStyleModifier")
        }, call: "labelStyle")
        return try Inspector.attribute(path: "modifier|style", value: modifier)
    }
}

// MARK: - LabelStyle inspection

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public extension LabelStyle {
    func inspect() throws -> InspectableView<ViewType.ClassifiedView> {
        let config = LabelStyleConfiguration()
        let view = try makeBody(configuration: config).inspect()
        return try .init(view.content, parent: nil, index: nil)
    }
}

// MARK: - Style Configuration initializer

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
private extension LabelStyleConfiguration {
    struct Allocator { }
    init() {
        self = unsafeBitCast(Allocator(), to: Self.self)
    }
}
