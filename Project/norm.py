import sys,os
import pprint
import pandas as pd
import optparse
from fuzzywuzzy import fuzz, process

if __name__ == "__main__":
	ofp = sys.stdout
	mko = optparse.make_option
	usage = """Check the city slot\n%s --ocsv out.csv *""" % (sys.argv[0])
	cmdOptions = [
		mko('-i', '--icsv', metavar='IN_CSV', help='input'),
		mko('-o', '--ocsv', metavar='OUT_CSV', help='output'),
		mko('-p', '--population', metavar='POPULATION_CSV', help='population'),
		mko('--config', default= None)
	]

	parser = optparse.OptionParser(option_list=cmdOptions, usage=usage)
	options, args = parser.parse_args(sys.argv[1:])

	data = pd.read_csv(options.icsv)
	ofp.write('Before norm: number of rows %i, number of columns %i\n' % (len(data.index), len(data.columns)))

	#### location info -- need to get data and put them in the columns

	# load population csv
	pop = pd.read_csv(options.population)


	#### normalize costs info  -- gunna need to readjust db table since no longer int


	data['PROVINCIAL DEPARTMENT PAYMENTS'] = data['PROVINCIAL DEPARTMENT PAYMENTS'].fillna('unknown')
	data['PROVINCIAL DFAA PAYMENTS'] = data['PROVINCIAL DFAA PAYMENTS'].fillna('unknown')
	data['ESTIMATED TOTAL COST'] = data['ESTIMATED TOTAL COST'].fillna('unknown')
	data['NORMALIZED TOTAL COST'] = data['NORMALIZED TOTAL COST'].fillna('unknown')
	data['MUNICIPAL COSTS'] = data['MUNICIPAL COSTS'].fillna('unknown')
	data['OGD COSTS'] = data['OGD COSTS'].fillna('unknown')
	data['INSURANCE PAYMENTS'] = data['INSURANCE PAYMENTS'].fillna('unknown')
	data['NGO PAYMENTS'] = data['NGO PAYMENTS'].fillna('unknown')
	data['FEDERAL DFAA PAYMENTS'] = data['FEDERAL DFAA PAYMENTS'].fillna('unknown')
	data['FATALITIES'] = data['FATALITIES'].fillna('unknown')
	data['INJURED / INFECTED'] = data['INJURED / INFECTED'].fillna('unknown')
	data['EVACUATED'] = data['EVACUATED'].fillna('unknown')

	#drop rows where still nan
	data = data.dropna(subset=['EVENT CATEGORY'])
	data = data.dropna(subset=['EVENT GROUP'])
	#to_drop= ['note', 'Note', '*Note', '*note','*Note:', 'Note:', '*note:', 'note:','request']
	#drop row that contains note in first column
	data = data[~data['EVENT CATEGORY'].str.contains('Note')]

	# extract province 
	pop['Province'] = pop['Geographic name'].str.extract('.*\((.*)\).*', expand = True)
	pop['Province'] = pop['Province'].str.replace('.', '').str.lower()
	pop['Geographic name'] = pop['Geographic name'].str.lower().str.replace(r"\(.*\)","")

	# rows to delete -- if they have division (maybe more?)
	pop = pop[~pop['Geographic name'].str.contains('division')]

	# write the clean population 
	pop.to_csv('cleanedPop.csv')

	# need to compare the city info we have in disaster to the population stats

	# new disaster columns
	data['CITY']= ''
	data['PROVINCE']= ''
	data['COUNTRY']= ''

	# number of citizens
	citizens = pop['Population, 2011']

	# all the poossible cities
	# should concact with province
	choices = pop['Geographic name'].tolist()
	#df[df['A'].str.contains("hello")]
	quebec = pop[pop['Province'].str.contains('que')==True]
	quebec = quebec['Geographic name'].tolist()

	bc = pop[pop['Province'].str.contains('bc')==True]
	bc = bc['Geographic name'].tolist()
	print bc
	provinces = pop['Geographic name'].tolist()
	
	#for index, row in data.iterrows():
	for row in range(len(data.index)):	
		if data['PLACE'].iloc[row].find('QC') > 0:
			result = process.extractOne(data['PLACE'].iloc[row], quebec)
		if data['PLACE'].iloc[row].find('BC') > 0:
			result = process.extractOne(data['PLACE'].iloc[row], bc)
		else:
			result = process.extractOne(data['PLACE'].iloc[row], choices)

		if result and result[1] > 70 :

		#	set the row in data
			data['CITY'].iloc[row] = result[0] 
			provinceIndex = [choices.index(i) for i in choices if result[0] in i]
			data['PROVINCE'].iloc[row] = provinces[provinceIndex[0]] 
			data['COUNTRY'].iloc[row] = 'CA'
			#print row, result
		else:
			data['COUNTRY'].iloc[row] = 'OTHER'
			print row, result






	

	data.to_csv(options.ocsv)

	ofp.write('After norm: number of rows %i, number of columns %i\n' % (len(data.index), len(data.columns)))
	ofp.close()

	#print data.head






