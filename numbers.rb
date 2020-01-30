class NumberToString

  def initialize
    @units = [
      "cero",
      "uno",
      "dos",
      "tres",
      "cuatro",
      "cinco",
      "seis",
      "siete",
      "ocho",
      "nueve",
      "diez",
      "once",
      "doce",
      "trece",
      "catorce",
      "quince"
    ]
    @tens = [
      "cero",
      "diez",
      "veinte",
      "treinta",
      "cuarenta",
      "cincuenta",
      "sesenta",
      "setenta",
      "ochenta",
      "noventa"
    ]
    @hundreds = [
      "cero",
      "cien",
      "doscientos",
      "trescientos",
      "cuatrocientos",
      "quinientos",
      "seiscientos",
      "setecientos",
      "ochocientos",
      "novecientos"
    ]
    @tens_and = [
      "cero",
      "dieci",
      "veinti",
      "treinta y ",
      "cuarenta y ",
      "cincuenta y ",
      "sesenta y ",
      "setenta y ",
      "ochenta y ",
      "noventa y "
    ]
  end

  # INPUT STRING
  # OUTPUT STRING
  # iNGRESA UN RUT CHILENO CON FORMATO 11.111.111-1 o 11111111-1 Y RETORNA EL RUT EN PALABRAS
  def rut_to_string(rut)
    legal_number, legal_number_verification = rut.gsub(".", "").split("-")
    legal_number_string =  get_number(legal_number.to_i)
    if ["K", "k"].include?(legal_number_verification)
      legal_number_verification_string = "K"
    else
      legal_number_verification_string = get_number(legal_number_verification.to_i)
    end
    return "#{ legal_number_string } guión #{ legal_number_verification_string }"
  end

  # INPUT INTEGER
  # OUTPUT STRING
  # INGRESA UN NUMERO ENTERO Y RETORNA EL NUMERO EN PALABRAS
  def get_number(number)
    case number
    when 0..15
      return @units[number]
    when 16..99
      if number.digits.first == 0
        return @tens[number.digits.last]
      else
        d = @tens_and[number.digits.last]
        u = self.get_number(number.digits.first)
        return "#{ d }#{ u }"
      end
    when 100..999
      prefix = number.to_s[0]
      suffix = number.to_s[1..2]

      if number == 100
        return "cien"
      else
        if (prefix.to_i > 0 && suffix.to_i == 0)
          return @hundreds[number.digits.last]
        else
          c = @hundreds[number.digits.last]
          o = self.get_number("#{ number.digits[1] }#{ number.digits[0] }".to_i)
          total = "#{ c } #{ o }"
          if prefix.to_i == 1 && (1..99).include?(suffix.to_i)
            total = total.gsub("cien", "ciento")
          end
          return total
        end
      end
    when 1000..999999
      number_s = number.to_s.rjust(6, '0')
      prefix = number_s[0..2]
      suffix = number_s[3..5]

      if (prefix.to_i == 1)
        pre = "mil"
      else
        pre = "#{ self.get_number(prefix.to_i) } mil"
      end

      another = suffix.to_i
      if another == 0
        c = ""
      else
        c = self.get_number(another)
      end

      total = "#{ pre } #{ c }"

      if number.digits.count >= 5
        total = total.gsub("uno ", "un ")
      end

      return total
    when 1000000..999999999
      number_s = number.to_s.rjust(9, '0')
      prefix = number_s[0..2]
      suffix = number_s[3..8]
      if prefix.to_i == 1
        h = "un millón"
        if suffix == 0
          return h
        else
          return "#{ self.get_number(prefix.to_i) } millón #{ self.get_number(suffix.to_i) }"
        end
      else
        pre = self.get_number(prefix.to_i)
        su = self.get_number(suffix.to_i)
        pre = pre.gsub("uno", "un")
        if (1000..1999).include?(suffix.to_i)
          su = su.gsub("mil", "un mil")
        end
        return "#{ pre } millones #{ su }"
      end
    end
  end

end