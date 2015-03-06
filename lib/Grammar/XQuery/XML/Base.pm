role Grammar::XQuery::XML::Base { 
    token QName               { <.PrefixedName> | <.UnprefixedName> }
    token CharRef             {
        [    
        | '&#' [0..9]+ ';'
        | '&#x' <+[0..9] +[a..fA..F]>+ ';'
        ]
    }

    token PITarget            { <.Name  -[ [Xx] [Mm] [Ll] ] }
    token PrefixedName        { <.Prefix> ':' <.LocalPart> }
    token UnprefixedName      { <.LocalPart> } 
    token LocalPart           { <.NCName> }
    token Prefix              { <.NCName> }
    token S                   { \x[20,9,D,A]+ }
    token NCName              { <.Name -[<.Char>* ':' <.Char>*]> }
    token Name                { <.NameStartChar> [<.NameChar>]*  }
    token NameStartChar       { 
        | ':' 
        | [a-zA-Z] 
        | '_' 
        | <[\x[C0]..\x[D6]]>
        | <[\x[D8]..\x[F6]]>
        | <[\x[F8]..\x[2FF]]>
        | <[\x[370]..\x[37D]]>
        | <[\x[37F]..\x[FFF]]>
        | <[\x[200C]..\x[200D]]>
        | <[\x[2070]..\x[218F]]>
        | <[\x[2C00]..\x[2FEF]]>
        | <[\x[3001]..\x[D7FF]]>
        | <[\x[F900]..\x[FDCF]]>
        | <[\x[FDF0]..\x[FFFD]]>
        | <[\x[10000]..\x[EFFFF]]>
    }
    token NameChar            { 
        | <.NameStartChar> 
        | '-' 
        | '.' 
        | [0..9] 
        | \x[B7] 
        | <[\x[0300]..\x[036F]]> 
        | <[\x[203F]..\x[2040]]>
    }
    token Char                {
        | \x[9] 
        | \x[A] 
        | \x[D] 
        | <[[\x[20]..\x[D7FF]]> 
        | <[\x[E000]..\x[FFFD]> 
        | <[\x[10000]..\x[10FFFF]]>
    } 
}