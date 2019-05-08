extension UIColor {
    
    /**
     Decomposes UIColor to its RGBA components
     */
    public var rgbColor: RGBColor {
        get {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return RGBColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    /**
     Decomposes UIColor to its HSBA components
     */
    public var hsbColor: HSBColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return HSBColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /**
     Holds the CGFloat values of HSBA components of a color
     */
    public struct HSBColor {
        public var hue: CGFloat
        public var saturation: CGFloat
        public var brightness: CGFloat
        public var alpha: CGFloat
        
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
        public var red: CGFloat
        public var green: CGFloat
        public var blue: CGFloat
        public var alpha: CGFloat
        
        public var uiColor: UIColor {
            get {
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }
    }
}

public class UBSAColour {
    
    public static func getTextColour(forColour colour: UIColor) -> UIColor {
        let brightness = colour.hsbColor.brightness;
        if(brightness <= 0.5) {
            return UIColor.white;
        } else {
            return UIColor.black;
        }
    }
    public static func getTransparentColour(forColour colour: UIColor) -> UIColor {
        return UIColor(hue: colour.hsbColor.hue, saturation: colour.hsbColor.saturation, brightness: colour.hsbColor.brightness, alpha: 0.0);
    }
}
