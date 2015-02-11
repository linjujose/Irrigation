require 'csv'
require 'roo'
require 'date'
class PagesController < ApplicationController
	helper_method :help
	helper_method :convertdate
	def convertdate(d)
		d[0],d[3],d[1],d[4] = d[3],d[0],d[4],d[1]
		return d
	end
	def help(p)
	  	dailyDaisy  = DailyDaisy.all
	  	pDate = Date.parse(convertdate(p[:pDate]))
	  	cropType = p[:cropType]
	  	hDate = Date.parse(convertdate(p[:hDate]))
	  	iDate = Date.parse(convertdate(p[:iDate]))
	  	aDate = Date.parse(p[:seasonA])
	  	bDate = Date.parse(p[:seasonB])
	  	cDate = Date.parse(p[:seasonC])
	  	sEfficiency = p[:sEfficiency].to_i
	  	pDischarge = p[:pDischarge].to_i
	  	eTc = Array.new(4)
	  	eTc[0] = p[:ABReplacement].to_i
	  	eTc[1] = p[:BCReplacement].to_i
	  	eTc[2] = p[:CDReplacement].to_i
	  	eTc[3] = p[:DEReplacement].to_i
	  	kc= Array.new(4)

	  	cropCoeff = CSV.read("app/assets/files/Crop Coefficients.csv")
	  	cropCoeff.each {|coeffs|
	  		if cropType.eql?coeffs[1] 
	  			(0..3).each {|j|
	  				kc[j] = coeffs[j+5]
	  			}
	  			break
	  		end
	  	}
	  	i=1
	  	j=0
	  	sum=0
	  	sumPreci=0
	  	
	  	dlength = dailyDaisy.length
	  	(pDate..iDate).select {|cDate|
	  		# ciDate = Date.parse(dailyDaisy[i]["Date"])
	  		kcCurr = -1
  			if cDate < aDate
  				kcCurr = 0 
  			elsif cDate < bDate
  				kcCurr = 1
  			elsif cDate < cDate
  				kcCurr = 2
  			else cDate < bDate
  				kcCurr = 3
  			end

	  		while (!((cDate-dailyDaisy[i]["Date"]).to_i ==j) && i<dlength)
	  			i+=1
		  		if(i==dlength)
		  			i=0
		  			j+=365
		  		end
		  	end
		  	if pIrr = PastIrrigation.where(Date: cDate).first
		  		sumPreci+=pIrr["Value"]
		  	end

		  	sum+=dailyDaisy[i]["Eto"]*kcCurr;
		  	sumPreci+=dailyDaisy[i]["Precip"];
	  	}
	  	etcval = 0
	  	if iDate < aDate
			etcval = eTc[0] 
		elsif cDate < bDate
			etcval = eTc[1]
		elsif cDate < cDate
			etcval = eTc[2]
		else cDate < bDate
			etcval = eTc[3]
		end
	  	wRequire = sum - sumPreci + ((sum- sumPreci)*(100-sEfficiency)/100)
	  	irrRequire = wRequire*etcval/100
	  	pHours = (irrRequire*27154)/(pDischarge*60)

		xml = {:type => "calculate",:irrRequire => irrRequire , :pHours => pHours}
		return xml
	end

  def home
  	logger.info("Called Home Page")
  	@cropCoeff = CSV.read("app/assets/files/Crop Coefficients.csv")
  	@cropCoeff.shift
  end

  def result
  	render "result"
  end

  def importPage
  end

  def importDaisy
  	logger.info("calledImport Daisy")
  	DailyDaisy.import(params[:file])
  	flash[:info] = "Data Loading successful";
  	redirect_to :action => 'home'
  end

  def add
	if request.xhr?
		if params[:buttonClicked] == "1"
			logger.debug("Called Submit")
			newirr = PastIrrigation.new
		  	newirr.Date = Date.parse(convertdate(params[:iDate]))
		  	newirr.Crop = params[:cropType]
		  	newirr.Value = params[:irVal].to_i
		  	if newirr.valid?
		  		logger.info("Saving Data into database")
		  		newirr.save
		  	else
		  		logger.warn("Error in saving the data")
		  	end
			render :xml => {:type => "submit"}	
	  	else
			logger.debug("Clicked calculate")
			txt = help params
			render :xml =>  txt
	  	end
	end
  end
end
