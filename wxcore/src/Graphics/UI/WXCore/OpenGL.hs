--------------------------------------------------------------------------------
{-| Module      :  OpenGL
    Copyright   :  (c) Daan Leijen 2003
    License     :  wxWindows

    Maintainer  :  daan@cs.uu.nl
    Stability   :  provisional
    Portability :  portable
  
    Convenience wrappers for the openGL canvas window ('GLCanvas').
-}
--------------------------------------------------------------------------------
module Graphics.UI.WXCore.OpenGL
   ( 
   -- * Types
     GLCanvas, GLAttribute(..)
   -- * Creation
   , glCanvasCreateDefault
   , glCanvasCreateEx
   , glCanvasCreateSharedEx
   -- * Usage
   , glCanvasSetCurrent
   , glCanvasSwapBuffers
   , glCanvasSetColour
   ) where


import Graphics.UI.WXCore.WxcTypes
import Graphics.UI.WXCore.WxcDefs
import Graphics.UI.WXCore.WxcClasses
import Graphics.UI.WXCore.Types

import Foreign
import Foreign.Ptr
import Foreign.C.String
import Foreign.Marshal.Array



{----------------------------------------------------------
  Attributes
----------------------------------------------------------}
-- | OpenGL window ('GLCanvas') attributes.
data GLAttribute
  = GL_RGBA                -- ^ Use true colour  
  | GL_BUFFER_SIZE Int     -- ^ Bits for buffer if not 'GL_RGBA' defined also
  | GL_LEVEL Int           -- ^ 0 for main buffer, >0 for overlay, <0 for underlay  
  | GL_DOUBLEBUFFER        -- ^ Use doublebuffer  
  | GL_STEREO              --  ^ Use stereoscopic display  
  | GL_AUX_BUFFERS Int     -- ^ Number of auxiliary buffers (not all implementation support this option)  
  | GL_MIN_RED Int         -- ^ Use red buffer with at least /argument/ bits (> MIN_RED bits)  
  | GL_MIN_GREEN Int       -- ^ Use green buffer with at least /argument/ bits (> MIN_GREEN bits)  
  | GL_MIN_BLUE Int        -- ^ Use blue buffer with at least /argument/ bits (> MIN_BLUE bits)  
  | GL_MIN_ALPHA Int       -- ^ Use alpha buffer with at least /argument/ bits (> MIN_ALPHA bits)  
  | GL_DEPTH_SIZE Int      -- ^ Bits for Z-buffer (0,16,32)  
  | GL_STENCIL_SIZE Int    -- ^ Bits for stencil buffer  
  | GL_MIN_ACCUM_RED Int   -- ^ Use red accum buffer with at least /argument/ bits (> MIN_ACCUM_RED bits)  
  | GL_MIN_ACCUM_GREEN Int -- ^ Use green buffer with at least /argument/ bits (> MIN_ACCUM_GREEN bits)  
  | GL_MIN_ACCUM_BLUE Int  -- ^ Use blue buffer with at least /argument/ bits (> MIN_ACCUM_BLUE bits)  
  | GL_MIN_ACCUM_ALPHA Int -- ^ Use blue buffer with at least /argument/ bits (> MIN_ACCUM_ALPHA bits) 


encodeAttributes :: [GLAttribute] -> [Int]
encodeAttributes attributes
  = concatMap encodeAttribute attributes

encodeAttribute attr
  = case attr of
      GL_RGBA                -> [1]
      GL_BUFFER_SIZE n       -> [2,n]
      GL_LEVEL n             -> [3,n]
      GL_DOUBLEBUFFER        -> [4]
      GL_STEREO              -> [5]
      GL_AUX_BUFFERS n       -> [6,n]
      GL_MIN_RED n           -> [7,n]
      GL_MIN_GREEN n         -> [8,n]
      GL_MIN_BLUE n          -> [9,n]
      GL_MIN_ALPHA n         -> [10,n]
      GL_DEPTH_SIZE n        -> [11,n]
      GL_STENCIL_SIZE n      -> [12,n]
      GL_MIN_ACCUM_RED n     -> [13,n]
      GL_MIN_ACCUM_GREEN n   -> [14,n]
      GL_MIN_ACCUM_BLUE n    -> [15,n]
      GL_MIN_ACCUM_ALPHA n   -> [16,n]

-- | Create a standard openGL canvas window with a certain title and attributes.
glCanvasCreateDefault :: Window a -> Style -> String -> [GLAttribute] -> IO (GLCanvas ())
glCanvasCreateDefault parent style title attrs
  = glCanvasCreateEx parent idAny rectNull style title attrs nullPalette

-- | Create an openGL window. Use 'nullPalette' to use the default palette.
glCanvasCreateEx :: Window a -> Id -> Rect -> Style -> String -> [GLAttribute] -> Palette b -> IO (GLCanvas ())
glCanvasCreateEx parent id rect style title attributes palette
  = withArray0 (toCInt 0) (map toCInt (encodeAttributes attributes)) $ \pattrs ->
    glCanvasCreate parent id rect style title pattrs palette

-- | Create a shared openGL window. Use 'nullPalette' to use the default palette.
glCanvasCreateSharedEx :: Window a -> GLCanvas b -> Id -> Rect -> Style -> String -> [GLAttribute] -> Palette c -> IO (GLCanvas ())
glCanvasCreateSharedEx parent shared id rect style title attributes palette
  = withArray0 (toCInt 0) (map toCInt (encodeAttributes attributes)) $ \pattrs ->
    glCanvasCreateShared parent shared id rect style title pattrs palette
