use v6;
use Grammar::XQuery::XML::Base;

# TODO:
# explicit whitespace handles

grammar Grammar::XQuery does Grammar::XQuery::XML::Base { 
    token Module                    { <.VersionDecl>? [<.LibraryModule> | <.MainModule>] }
    token VersionDecl               { 
        'xquery' 
        [
        | ['encoding' <.StringLiteral>] 
        | ['version' <.StringLiteral> ['encoding' <.StringLiteral>]?]
        ] 
        <.Separator> 
    }
    token MainModule                { <.Prolog> <.QueryBody> }
    token LibraryModule             { <.ModuleDecl> <.Prolog> }
    token ModuleDecl                { 'module' 'namespace' <.NCName> '=' <.URILiteral> <.Separator> }
    token Prolog                    { 
        [
            [
            | <.DefaultNamespaceDecl> 
            | <.Setter> 
            | <.NamespaceDecl> 
            | <.Import>
            ] 
        <.Separator>
        ]* 
        [
            [ 
            | <.ContextItemDecl> 
            | <.AnnotatedDecl> 
            | <.OptionDecl>
            ] 
        <.Separator>
        ]* 
    }
    token Separator                 { ';' }
    token Setter                    { 
        | <.BoundarySpaceDecl> 
        | <.DefaultCollationDecl> 
        | <.BaseURIDecl> 
        | <.ConstructionDecl> 
        | <.OrderingModeDecl> 
        | <.EmptyOrderDecl> 
        | <.CopyNamespacesDecl> 
        | <.DecimalFormatDecl> 
    }
    token BoundarySpaceDecl         { 'declare' 'boundary-space' ['preserve' | 'strip'] }
    token DefaultCollationDecl      { 'declare' 'default' 'collation' <.URILiteral> }
    token BaseURIDecl               { 'declare' 'base-uri' <.URILiteral> }
    token ConstructionDecl          { 'declare' 'construction' ['strip' | 'preserve'] }
    token OrderingModeDecl          { 'declare' 'ordering' ['ordered' | 'unordered'] }
    token EmptyOrderDecl            { 'declare' 'default' 'order' 'empty' ['greatest' | 'least'] }
    token CopyNamespacesDecl        { 'declare' 'copy-namespaces' <.PreserveMode> ',' <.InheritMode> }
    token PreserveMode              { 'preserve' | 'no-preserve' }
    token InheritMode               { 'inherit'  | 'no-inherit' }
    token DecimalFormatDecl         { 
        'declare' 
        [
        | ['decimal-format' <.EQName>] 
        | ['default' 'decimal-format']
        ] 
        [<.DFPropertyName> '=' <.StringLiteral>]* 
    }
    token DFPropertyName            { 
        | 'decimal-separator' 
        | 'grouping-separator' 
        | 'infinity' 
        | 'minus-sign' 
        | 'NaN' 
        | 'percent' 
        | 'per-mille' 
        | 'zero-digit' 
        | 'digit' 
        | 'pattern-separator' 
    }
    token Import                    { <.SchemaImport> | <.ModuleImport> }
    token SchemaImport              { 'import' 'schema' <.SchemaPrefix>? <.URILiteral> ['at' <.URILiteral> [',' <.URILiteral>]*]? }
    token SchemaPrefix              { ['namespace' <.NCName> '='] | ['default' 'element' 'namespace'] }
    token ModuleImport              { 'import' 'module' ['namespace' <.NCName> '=']? <.URILiteral> ['at' <.URILiteral> [',' <.URILiteral>]*]? }
    token NamespaceDecl             { 'declare' 'namespace' <.NCName> '=' <.URILiteral> }
    token DefaultNamespaceDecl      { 
        'declare' 'default' 
        [
        | 'element' 
        | 'function'
        ] 
        'namespace' 
        <.URILiteral> 
    }
    token AnnotatedDecl             { 
        'declare' <.Annotation>* 
        [
        | <.VarDecl> 
        | <.FunctionDecl>
        ] 
    }
    token Annotation                { '%' <.EQName> ['(' <.Literal> [',' <.Literal>]* ')']? }
    token VarDecl                   { 
        'variable' '$' <.VarName> 
        <.TypeDeclaration>? 
        [
        | [':=' <.VarValue>] 
        | ['external' [':=' <.VarDefaultValue>]?]
        ] 
    }
    token VarValue                  { <.ExprSingle> }
    token VarDefaultValue           { <.ExprSingle> }
    token ContextItemDecl           { 
        'declare' 'context' 'item' 
        [
            'as' <.ItemType>]? 
            [
            | [':=' <.VarValue>] 
            | ['external' [':=' <.VarDefaultValue>]?]
            ]
        ] 
    }
    token FunctionDecl              { 'function' <.EQName> '(' <.ParamList>? ')' ['as' <.SequenceType>]? [<.FunctionBody> | 'external'] }
    token ParamList                 { <.Param> [',' <.Param>]* }
    token Param                     { '$' <.EQName> <.TypeDeclaration>? }
    token FunctionBody              { <.EnclosedExpr> }
    token EnclosedExpr              { '{' <.Expr> '}' }
    token OptionDecl                { 'declare' 'option' <.EQName> <.StringLiteral> }
    token QueryBody                 { <.Expr> }
    token Expr                      { <.ExprSingle> [',' <.ExprSingle>]* }
    token ExprSingle                { 
        | <.FLWORExpr> 
        | <.QuantifiedExpr>
        | <.SwitchExpr>
        | <.TypeswitchExpr>
        | <.IfExpr>
        | <.TryCatchExpr>
        | <.OrExpr>
    }
    token FLWORExpr                 { <.InitialClause> <.IntermediateClause>* <.ReturnClause> }
    token InitialClause             { 
        | <.ForClause> 
        | <.LetClause> 
        | <.WindowClause> 
    }
    token IntermediateClause        { 
        | <.InitialClause> 
        | <.WhereClause> 
        | <.GroupByClause> 
        | <.OrderByClause> 
        | <.CountClause> 
    }
    token ForClause                 { 'for' <.ForBinding> [',' <.ForBinding>]* }
    token ForBinding                { '$' <.VarName> <.TypeDeclaration>? <.AllowingEmpty>? <.PositionalVar>? 'in' <.ExprSingle> }
    token AllowingEmpty             { 'allowing' 'empty' }
    token PositionalVar             { 'at' '$' <.VarName> }
    token LetClause                 { 'let' <.LetBinding> [',' <.LetBinding>]* }
    token LetBinding                { '$' <.VarName> <.TypeDeclaration>? ':=' <.ExprSingle> }
    token WindowClause              { 'for' [<.TumblingWindowClause> | <.SlidingWindowClause>] }
    token TumblingWindowClause      { 'tumbling' 'window' '$' <.VarName> <.TypeDeclaration>? 'in' <.ExprSingle> <.WindowStartCondition> <.WindowEndCondition>? }
    token SlidingWindowClause       { 'sliding' 'window' '$' <.VarName> <.TypeDeclaration>? 'in' <.ExprSingle> <.WindowStartCondition> <.WindowEndCondition> }
    token WindowStartCondition      { 'start' <.WindowVars> 'when' <.ExprSingle> }
    token WindowEndCondition        { 'only'? 'end' <.WindowVars> 'when' <.ExprSingle> }
    token WindowVars                { ['$' <.CurrentItem>]? <.PositionalVar>? ['previous' '$' <.PreviousItem>]? ['next' '$' <.NextItem>]? }
    token CurrentItem               { <.EQName> }
    token PreviousItem              { <.EQName> }
    token NextItem                  { <.EQName> }
    token CountClause               { 'count' '$' <.VarName> }
    token WhereClause               { 'where' <.ExprSingle> }
    token GroupByClause             { 'group' 'by' <.GroupingSpecList> }
    token GroupingSpecList          { <.GroupingSpec> [',' <.GroupingSpec>]* }
    token GroupingSpec              { <.GroupingVariable> [<.TypeDeclaration>? ':=' <.ExprSingle>]? ['collation' <.URILiteral>]? }
    token GroupingVariable          { '$' <.VarName> }
    token OrderByClause             { [['order' 'by'] | ['stable' 'order' 'by']] <.OrderSpecList> }
    token OrderSpecList             { <.OrderSpec> [',' <.OrderSpec>]* }
    token OrderSpec                 { <.ExprSingle> <.OrderModifier> }
    token OrderModifier             { 
        [
        | 'ascending' 
        | 'descending'
        ]? 
        [
            'empty' 
            ['greatest' | 'least']
        ]? 
        ['collation' <.URILiteral>]? 
    }
    token ReturnClause              { 'return' <.ExprSingle> }
    token QuantifiedExpr            { ['some' | 'every'] '$' <.VarName> <.TypeDeclaration>? 'in' <.ExprSingle> [',' '$' <.VarName> <.TypeDeclaration>? 'in' <.ExprSingle>]* 'satisfies' <.ExprSingle> }
    token SwitchExpr                { 'switch' '(' <.Expr> ')' <.SwitchCaseClause>+ 'default' 'return' <.ExprSingle> }
    token SwitchCaseClause          { ['case' <.SwitchCaseOperand>]+ 'return' <.ExprSingle> }
    token SwitchCaseOperand         { <.ExprSingle> }
    token TypeswitchExpr            { 'typeswitch' '(' <.Expr> ')' <.CaseClause>+ 'default' ['$' <.VarName>]? 'return' <.ExprSingle> }
    token CaseClause                { 'case' ['$' <.VarName> 'as']? <.SequenceTypeUnion> 'return' <.ExprSingle> }
    token SequenceTypeUnion         { <.SequenceType> ['|' <.SequenceType>]* }
    token IfExpr                    { 'if' '(' <.Expr> ')' 'then' <.ExprSingle> 'else' <.ExprSingle> }
    token TryCatchExpr              { <.TryClause> <.CatchClause>+ }
    token TryClause                 { 'try' '{' <.TryTargetExpr> '}' }
    token TryTargetExpr             { <.Expr> }
    token CatchClause               { 'catch' <.CatchErrorList> '{' <.Expr> '}' }
    token CatchErrorList            { <.NameTest> ['|' <.NameTest>]* }
    token OrExpr                    { <.AndExpr> [ 'or' <.AndExpr> ]* }
    token AndExpr                   { <.ComparisonExpr> [ 'and' <.ComparisonExpr> ]* }
    token ComparisonExpr            { 
        <.StringConcatExpr> 
        [ 
            [
            | <.ValueComp>
            | <.GeneralComp>
            | <.NodeComp>
            ] 
        <.StringConcatExpr> 
        ]?
    }
    token StringConcatExpr          { <.RangeExpr> [ '||' <.RangeExpr> ]* }
    token RangeExpr                 { <.AdditiveExpr> [ 'to' <.AdditiveExpr> ]? }
    token AdditiveExpr              { 
        <.MultiplicativeExpr> 
        [ <[+-]> <.MultiplicativeExpr> ]* 
    }
    token MultiplicativeExpr        { 
        <.UnionExpr> 
        [ 
            [
            | '*' 
            | 'div' 
            | 'idiv' 
            | 'mod'
            ] 
        <.UnionExpr> 
        ]* 
    }
    token UnionExpr                 { 
        <.IntersectExceptExpr> 
        [ 
        | ['union' | '|']
        | <.IntersectExceptExpr> 
        ]* 
    }
    token IntersectExceptExpr       { <.InstanceofExpr> [ ['intersect' | 'except'] <.InstanceofExpr> ]* }
    token InstanceofExpr            { <.TreatExpr> [ 'instance' 'of' <.SequenceType> ]? }
    token TreatExpr                 { <.CastableExpr> [ 'treat' 'as' <.SequenceType> ]? }
    token CastableExpr              { <.CastExpr> [ 'castable' 'as' <.SingleType> ]? }
    token CastExpr                  { <.UnaryExpr> [ 'cast' 'as' <.SingleType> ]? }
    token UnaryExpr                 { ['-' | '+']* <.ValueExpr> }
    token ValueExpr                 { <.ValidateExpr> | <.ExtensionExpr> | <.SimpleMapExpr> }
    token GeneralComp               { '='  | '!=' | '<'  | '<=' | '>'  | '>=' }
    token ValueComp                 { 'eq' | 'ne' | 'lt' | 'le' | 'gt' | 'ge' }
    token NodeComp                  { 'is' | '<<' | '>>' }
    token ValidateExpr              { 
        'validate' 
        [
        | <.ValidationMode> 
        | ['type' <.TypeName>]
        ]? '
        {' <.Expr> '}' 
    }
    token ValidationMode            { 'lax' | 'strict' }
    token ExtensionExpr             { <.Pragma>+ '{' <.Expr>? '}' }
    token Pragma                    { '[#' <.S>? <.EQName> [<.S> <.PragmaContents>]? '#]' }
    token PragmaContents            { [<.Char>* - [<.Char>* '#]' <.Char>*]] }
    token SimpleMapExpr             { <.PathExpr> ['!' <.PathExpr>]* }
    token PathExpr                  { 
        | ['/' <.RelativePathExpr>?]
        | ['//' <.RelativePathExpr>]
        | <.RelativePathExpr>  
    }
    token RelativePathExpr          { <.StepExpr> [['/' | '//'] <.StepExpr>]* }
    token StepExpr                  { <.PostfixExpr> | <.AxisStep> }
    token AxisStep                  { [<.ReverseStep> | <.ForwardStep>] <.PredicateList> }
    token ForwardStep               { 
        | [<.ForwardAxis> <.NodeTest>] 
        | <.AbbrevForwardStep> 
    }
    token ForwardAxis               { 
        | ['child'              '::'] 
        | ['descendant'         '::']
        | ['attribute'          '::']
        | ['self'               '::']
        | ['descendant-or-self' '::']
        | ['following-sibling'  '::']
        | ['following'          '::']
    }
    token AbbrevForwardStep         { '@'? <.NodeTest> }
    token ReverseStep               { 
        | [<.ReverseAxis> <.NodeTest>] 
        | <.AbbrevReverseStep> 
    }
    token ReverseAxis               { 
        | ['parent'            '::'] 
        | ['ancestor'          '::']
        | ['preceding-sibling' '::']
        | ['preceding'         '::']
        | ['ancestor-or-self'  '::']
    }
    token AbbrevReverseStep         { '..' }
    token NodeTest                  { <.KindTest> | <.NameTest> }
    token NameTest                  { <.EQName>   | <.Wildcard> }
    token Wildcard                  { 
        | '*' 
        | [<.NCName> ':' '*']
        | ['*' ':' <.NCName>]
        | [<.BracedURILiteral> '*']
    }
    token PostfixExpr               { <.PrimaryExpr> [<.Predicate> | <.ArgumentList>]* }
    token ArgumentList              { '(' [<.Argument> [',' <.Argument>]*]? ')' }
    token PredicateList             { <.Predicate>* }
    token Predicate                 { '[' <.Expr> ']' }
    token PrimaryExpr               { 
        | <.Literal>
        | <.VarRef>
        | <.ParenthesizedExpr>
        | <.ContextItemExpr>
        | <.FunctionCall>
        | <.OrderedExpr>
        | <.UnorderedExpr>
        | <.Constructor>
        | <.FunctionItemExpr>
    }
    token Literal                   { <.NumericLiteral> | <.StringLiteral> }
    token NumericLiteral            { <.IntegerLiteral> | <.DecimalLiteral> | <.DoubleLiteral> }
    token VarRef                    { '$' <.VarName> }
    token VarName                   { <.EQName> }
    token ParenthesizedExpr         { '(' <.Expr>? ')' }
    token ContextItemExpr           { '.' }
    token OrderedExpr               { 'ordered' '{' <.Expr> '}' }
    token UnorderedExpr             { 'unordered' '{' <.Expr> '}' }
    token FunctionCall              { <.EQName> <.ArgumentList> }
                    
    token Argument                  { <.ExprSingle> | <.ArgumentPlaceholder> }
    token ArgumentPlaceholder       { '?' }
    token Constructor               { <.DirectConstructor>    | <.ComputedConstructor> }
    token DirectConstructor         { <.DirElemConstructor> } | <.DirCommentConstructor> | <.DirPIConstructor> }
    token DirElemConstructor        { 
        '<' <.QName> <.DirAttributeList> 
        [
        | '/>' 
        | ['>' <.DirElemContent>* '</' <.QName> <.S>? '>']
        ] 
    }
    token DirAttributeList          { [<.S> [<.QName> <.S>? '=' <.S>? <.DirAttributeValue>]?]* }
    token DirAttributeValue         { 
        | ["\'" [<.EscapeQuot> | <.QuotAttrValueContent>]* "\'"] 
        | ["\'" [<.EscapeApos> | <.AposAttrValueContent>]* "\'"]    
    }
    token QuotAttrValueContent      { <.QuotAttrContentChar> | <.CommonContent> }
    token AposAttrValueContent      { <.AposAttrContentChar> | <.CommonContent> }
    token DirElemContent            { 
        | <.DirectConstructor> 
        | <.CDataSection>
        | <.CommonContent>
        | <.ElementContentChar>
    }
    token CommonContent             { 
        | <.PredefinedEntityRef> 
        | <.CharRef> 
        | ['{{' | '}}'] 
        | <.EnclosedExpr> 
    }
    token DirCommentConstructor     { '<!--' <.DirCommentContents> '-->' }
    token DirCommentContents        { 
        [
        | [<.Char> - '-'] 
        | ['-' [<.Char -[\-]>]
        ]* 
    }
    token DirPIConstructor          { '<?' <.PITarget> [S <.DirPIContents>]? '?>' }
    token DirPIContents             { [<.Char>* - [<.Char>* '?>' <.Char>*]] }
    token CDataSection              { '<![<.CDATA>[' <.CDataSectionContents> ']]>' }
    token CDataSectionContents      { [<.Char>* - [<.Char>* ']]>' <.Char>*]] }
    token ComputedConstructor       { 
        | <.CompDocConstructor> 
        | <.CompElemConstructor>
        | <.CompAttrConstructor>
        | <.CompNamespaceConstructor>
        | <.CompTextConstructor>
        | <.CompCommentConstructor>
        | <.CompPIConstructor> 
    }
    token CompDocConstructor        { 'document' '{' <.Expr> '}' }
    token CompElemConstructor       { 
        'element' 
        [
        | <.EQName> 
        | ['{' <.Expr> '}']
        ] 
        '{' <.ContentExpr>? '}' 
    }
    token ContentExpr               { <.Expr> }
    token CompAttrConstructor       { 
        'attribute' 
        [
        | <.EQName> 
        | ['{' <.Expr> '}']
        ] 
        '{' <.Expr>? '}' 
    }
    token CompNamespaceConstructor  { 'namespace' [<.Prefix> | ['{' <.PrefixExpr> '}']] '{' <.URIExpr> '}' }
    token Prefix                    { <.NCName> }
    token PrefixExpr                { <.Expr> }
    token URIExpr                   { <.Expr> }
    token CompTextConstructor       { 'text' '{' <.Expr> '}' }
    token CompCommentConstructor    { 'comment' '{' <.Expr> '}' }
    token CompPIConstructor         { 
        'processing-instruction' 
        [
        | <.NCName> 
        | ['{' <.Expr> '}']
        ] 
        '{' <.Expr>? '}' 
    }
    token FunctionItemExpr          { 
        | <.NamedFunctionRef> 
        | <.InlineFunctionExpr> 
    }
    token NamedFunctionRef          { <.EQName> '#' <.IntegerLiteral> }
    token InlineFunctionExpr        { <.Annotation>* 'function' '(' <.ParamList>? ')' ['as' <.SequenceType>]? <.FunctionBody> }
    token SingleType                { <.SimpleTypeName> '?'? }
    token TypeDeclaration           { 'as' <.SequenceType> }
    token SequenceType              { 
        | ['empty-sequence' '(' ')'] 
        | [<.ItemType> <.OccurrenceIndicator>?] 
    }
    token OccurrenceIndicator       { 
        | '?' 
        | '*' 
        | '+' 
    }
    token ItemType                  { 
        | <.KindTest> 
        | ['item' '(' ')'] 
        | <.FunctionTest> 
        | <.AtomicOrUnionType> 
        | <.ParenthesizedItemType> }
    }
    token AtomicOrUnionType         { <.EQName> }
    token KindTest                  { 
        | <.DocumentTest> 
        | <.ElementTest>
        | <.AttributeTest>
        | <.SchemaElementTest>
        | <.SchemaAttributeTest>
        | <.PITest>
        | <.CommentTest>
        | <.TextTest>
        | <.NamespaceNodeTest>
        | <.AnyKindTest> 
    }
    token AnyKindTest               { 'node' '(' ')' }
    token DocumentTest              { 
        'document-node' '(' 
        [
        | <.ElementTest> 
        | <.SchemaElementTest>
        ]? 
        ')' 
    }
    token TextTest                  { 'text' '(' ')' }
    token CommentTest               { 'comment' '(' ')' }
    token NamespaceNodeTest         { 'namespace-node' '(' ')' }
    token PITest                    { 
        'processing-instruction' '(' 
        [
        | <.NCName> 
        | <.StringLiteral>
        ]? 
        ')' 
    }
    token AttributeTest             { 'attribute' '(' [<.AttribNameOrWildcard> [',' <.TypeName>]?]? ')' }
    token AttribNameOrWildcard      { 
        | <.AttributeName> 
        | '*' 
    }
    token SchemaAttributeTest       { 'schema-attribute' '(' <.AttributeDeclaration> ')' }
    token AttributeDeclaration      { <.AttributeName> }
    token ElementTest               { 'element' '(' [<.ElementNameOrWildcard> [',' <.TypeName> '?'?]?]? ')' }
    token ElementNameOrWildcard     { 
        | <.ElementName> 
        | '*' 
    }
    token SchemaElementTest         { 'schema-element' '(' <.ElementDeclaration> ')' }
    token ElementDeclaration        { <.ElementName> }
    token AttributeName             { <.EQName> }
    token ElementName               { <.EQName> }
    token SimpleTypeName            { <.TypeName> }
    token TypeName                  { <.EQName> }
    token FunctionTest              { 
        <.Annotation>* 
        [
        | <.AnyFunctionTest> 
        | <.TypedFunctionTest>
        ] 
    }
    token AnyFunctionTest           { 'function' '(' '*' ')' }
    token TypedFunctionTest         { 
        'function' '(' 
        [<.SequenceType> [',' <.SequenceType>]*]? 
        ')' 'as' <.SequenceType> }
    token ParenthesizedItemType     { '(' <.ItemType> ')' }
    token URILiteral                { <.StringLiteral> }
    token EQName                    { 
        | <.QName> 
        | <.URIQualifiedName> 
    } 
}
