/**
 
 UIColor extension
 
 - Credit: https://stackoverflow.com/a/49655560
 */
extension UIColor {
    // MARK: - Conversions
    
    /**
     Decomposes UIColor to its RGBA components
     */
    public var rgbColor: RGBColor {
        get {
            ///Red
            var red: CGFloat = 0,
            ///Green
            green: CGFloat = 0,
            ///Blue
            blue: CGFloat = 0,
            ///Alpha
            alpha: CGFloat = 0;
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return RGBColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    /**
     Decomposes UIColor to its HSBA components
     */
    public var hsbColor: HSBColor {
        ///Hue
        var h: CGFloat = 0,
        ///Saturation
        s: CGFloat = 0,
        ///Brightness
        b: CGFloat = 0,
        ///Alpha
        a: CGFloat = 0;
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a);
        return HSBColor(hue: h, saturation: s, brightness: b, alpha: a);
    }
    
    //MARK: - Structs
    
    /**
     Holds the CGFloat values of HSBA components of a color
     */
    public struct HSBColor {
        ///Hue
        public var hue: CGFloat
        ///Saturation
        public var saturation: CGFloat
        ///Brightness
        public var brightness: CGFloat
        ///Alpha
        public var alpha: CGFloat
        
        ///Allows conversion of a hsbColour to a UIColor
        public var uiColor: UIColor {
            get {
                return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            }
        }
    }
    
    /**
     Holds the CGFloat values of RGBA components of a color
     */
    public struct RGBColor {
        ///Red
        public var red: CGFloat
        ///Green
        public var green: CGFloat
        ///Blue
        public var blue: CGFloat
        ///Alpha
        public var alpha: CGFloat
        
        ///Allows conversion of an RGBColour to a UIColor
        public var uiColor: UIColor {
            get {
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }
    }
}

/**
 # UBSAColour
 
 Ari Stassinopoulos
 
 Colour conversion utilities
 */
public class UBSAColour {
    private init() {}
    /**
     Checks if background colour is more black than white and returns a commensurate text colour
     
     - Parameter forColour: Background colour to process
     - Returns: Black or white depending on forColour brightness
    */
    public static func getTextColour(forColour colour: UIColor) -> UIColor {
        let brightness = colour.hsbColor.brightness;
        if(brightness <= 0.5) {
            return UIColor.white;
        } else {
            return UIColor.black;
        }
    }
    
}
