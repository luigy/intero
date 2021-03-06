-- | Types used separate to GHCi vanilla.

module GhciTypes where

import Data.Time
import GHC
import Intero.Compat
import Outputable

-- | Info about a module. This information is generated every time a
-- module is loaded.
data ModInfo =
  ModInfo {modinfoSummary :: !ModSummary
           -- ^ Summary generated by GHC. Can be used to access more
           -- information about the module.
          ,modinfoSpans :: ![SpanInfo]
           -- ^ Generated set of information about all spans in the
           -- module that correspond to some kind of identifier for
           -- which there will be type info and/or location info.
          ,modinfoInfo :: !ModuleInfo
           -- ^ Again, useful from GHC for accessing information
           -- (exports, instances, scope) from a module.
          ,modinfoLastUpdate :: !UTCTime
           -- ^ Last time the module was updated.
          ,modinfoImports :: ![LImportDecl StageReaderName]
           -- ^ Import declarations within this module.
          ,modinfoLocation :: !SrcSpan
           -- ^ The location of the module
          }

-- | Type of some span of source code. Most of these fields are
-- unboxed but Haddock doesn't show that.
data SpanInfo =
  SpanInfo {spaninfoStartLine :: {-# UNPACK #-} !Int
            -- ^ Start line of the span.
           ,spaninfoStartCol :: {-# UNPACK #-} !Int
            -- ^ Start column of the span.
           ,spaninfoEndLine :: {-# UNPACK #-} !Int
            -- ^ End line of the span (absolute).
           ,spaninfoEndCol :: {-# UNPACK #-} !Int
            -- ^ End column of the span (absolute).
           ,spaninfoType :: !(Maybe Type)
            -- ^ A pretty-printed representation fo the type.
           ,spaninfoVar :: !(Maybe Id)
            -- ^ The actual 'Var' associated with the span, if
            -- any. This can be useful for accessing a variety of
            -- information about the identifier such as module,
            -- locality, definition location, etc.
           }

instance Outputable SpanInfo where
  ppr (SpanInfo sl sc el ec ty v) =
    (int sl Outputable.<>
     text ":" Outputable.<>
     int sc Outputable.<>
     text "-") Outputable.<>
    (int el Outputable.<>
     text ":" Outputable.<>
     int ec Outputable.<>
     text ": ") Outputable.<>
    (ppr v Outputable.<>
     text " :: " Outputable.<>
     ppr ty)
