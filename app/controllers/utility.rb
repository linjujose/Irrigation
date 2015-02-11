class Utility
   attr_accessor :pDate, :cropType, :hDate, :iDate, :Etc

   def self.calculateVal(params)
  	#gets input to calculte the data and returns them
  	logger("Called calculateVal function")
  	
  	Kc[0]=0
  	cropCoeff = CSV.read("app/assets/files/Crop Coefficients.csv")
  	cropCoeff.each {|coeffs|
  		logger.warn(coeffs)
  		# if(coeffs[1]==cropType){
  		# 	(0..3){|j|
  		# 		Kc[j] = coeffs[j+5]
  		# 	}
  		# 	break;
  		# }
  	}
  	logger.warn("calculated the Kcs");
  	return {:type => "calculate"}
  end
end