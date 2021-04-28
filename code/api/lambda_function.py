import json
import boto3
from boto3.dynamodb.conditions import Key, Attr

print('Loading function')

reg_name = "us-east-1"
table_name = "devops-assignment"

dynamodb = boto3.resource('dynamodb', region_name=reg_name)
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
	#1. Parse out query string params
	resource = event["path"]
	
	responseObject = {}
	if resource == "/currentinterestrate":
		responseObject['body'], responseObject['statusCode'] = getCurrentInterestRate(event['queryStringParameters'])
	elif resource == "/listinterestrate":
		responseObject['body'], responseObject['statusCode'] = listInterestRate()
	elif resource == "/requestrate":
		responseObject['body'], responseObject['statusCode'] = requestRate(event['queryStringParameters'])
	else:
		responseObject['body'] = "page does not exist"
		responseObject['statusCode'] = 400
	
	responseObject['headers'] = {}
	responseObject['headers']['Content-Type'] = 'application/json'
	
	#4. Return the response object
	print("Completed processing request!!!")
	return responseObject

def getCurrentInterestRate(queryParams):
	"""
	gets the latest interest rate on a specific rate type

	queryParameter required:
		- type
		eg: type=goldloan
	"""
	try:
		# get data on provided type from DB
		response = table.scan(FilterExpression=Attr('Type').eq(queryParams["type"]))
		data = response['Items']
		while 'LastEvaluatedKey' in response:
			response = table.scan(FilterExpression=Attr('Type').eq(queryParams["type"]), ExclusiveStartKey=response['LastEvaluatedKey'])
			data.extend(response['Items'])
		
		# sort rows on timestamp
		timestamps = [a_dict["Timestamp"] for a_dict in data]
		timestamps.sort()
		
		# return latest row
		res_dictionary = "No record found"
		for dictionary in data:
			if timestamps[-1] == dictionary["Timestamp"]:
				res_dictionary = str(dictionary)
		
	except Exception as e:
		print(e)
		return {"There was an error on the server and the request could not be completed"}, 500
		
	return res_dictionary, 200

def listInterestRate():
	"""
	gets all interest rate data from the database

	No query params required
	"""
	try:
		# get all rows from table
		response = table.scan()
		data = response['Items']
		while 'LastEvaluatedKey' in response:
			response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
			data.extend(response['Items'])
			
	except Exception as e:
		print(e)
		return {"There was an error on the server and the request could not be completed"}, 500
		
	return str(data), 200

def requestRate(queryParams):
	"""
	gets the interest rate on a specific rate type, on a particular date

	queryParameter required:
		- type
		- timestamp

		eg: type=goldloan
		eg: timestamp=2019-05-15  -> YYYY-MM-DD
	"""
	try:
		# get data on provided type from DB
		response = table.scan(FilterExpression=Attr('Type').eq(queryParams["type"]))
		data = response['Items']
		while 'LastEvaluatedKey' in response:
			response = table.scan(FilterExpression=Attr('Type').eq(queryParams["type"]), ExclusiveStartKey=response['LastEvaluatedKey'])
			data.extend(response['Items'])
		
		# sort rows on timestamp
		timestamps = [a_dict["Timestamp"] for a_dict in data]
		timestamps.sort()
		
		# find the date less than or equal to passed date
		req_date = ""
		for date in timestamps:
			if queryParams["timestamp"] >= date:
				req_date = date
			else:
				break
			
		# return row having the above fetched date as timestamp
		res_dictionary = "No record found"
		if req_date != "":
			for dictionary in data:
				if req_date == dictionary["Timestamp"]:
					res_dictionary = str(dictionary)
		
	except Exception as e:
		print(e)
		return {"There was an error on the server and the request could not be completed"}, 500
		
	return str(res_dictionary), 200