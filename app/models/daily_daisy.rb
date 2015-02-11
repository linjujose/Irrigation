require 'roo'
class DailyDaisy < ActiveRecord::Base
	def self.import(file)
		logger.warn("Storing Davis Weather data")
		DailyDaisy.destroy_all
		book = Roo::Excelx.new("app/assets/files/Example File.xlsx")
	  	book.default_sheet = book.sheets.first
	  	row_stop = book.last_row
	  	logger.warn(row_stop)
	  	(2..row_stop).each {|i|
	  		newdata = DailyDaisy.new
	  		row_data = book.row(i)
	  		newdata.Stn_name = row_data[0]
			newdata.Date = row_data[1]
			newdata.JulianYear = row_data[2]
			newdata.MaxAirTem= row_data[3]
			newdata.MinAirTemp= row_data[4]
			newdata.MaxRelHum= row_data[5]
			newdata.MinRelHum= row_data[6]
			newdata.Precip= row_data[7]
			newdata.Eto= row_data[8]
			newdata.MaxWindSpeed= row_data[9]
			z = newdata.save
		}
	end


  def self.calculateVal(params)
  	#gets input to calculte the data and returns them
  	logger("Called calculateVal function")
  	dailyDaisy  = DailyDaisy.all
  	pDate = params[:pDate]
  	cropType = params[:cropType]
  	hDate = params[:hDate]
  	iDate = params[:iDate]
  	ETc[0] = params[:ABReplacement]
  	ETc[1] = params[:BCReplacement]
  	ETc[2] = params[:CDReplacement]
  	ETc[3] = params[:DEReplacement]
  	Kc[0]=0
  	cropCoeff = CSV.read("app/assets/files/Crop Coefficients.csv")
  	cropCoeff.each {|coeffs|
  		logger.warn(coeffs)
  		 #if(coeffs[1]==cropType){
  		 #	(0..3){|j|
  		 #		Kc[j] = coeffs[j+5]
  		 #	}
  		 #	break;
  		 #}
  	}
  	logger.warn("calculated the Kcs");
  	return {:type => "calculate"}
  end

end
