// Created: 2018-05-03
// Mike Tellinghuisen
// @mtellin
// Pre-Requisites: Need to have created a new Configuration Element called 'Brik' in folder Rubrik as base level
// It should have 3 attributes:
//	rubrikHost	string		https://rubrik.mtellin.lab/api/v1/
//	username	string		admin
//	password	SecureString	***
// Used to return a list of SLAs for a property group with external values

// GET CONFIGURATION ELEMENTS FOR REST HOST, USERNAME AND PASSWORD
var category = (Server.getConfigurationElementCategoryWithPath("Rubrik"));
var elements = category.configurationElements;

// Grab the values for the 3 elements defined to use later in the script
for each (var element in elements) {
		username = element.getAttributeWithKey("username").value;
		password = element.getAttributeWithKey("password").value;
		rubrikHost = element.getAttributeWithKey("rubrikHost").value;
}


var opMethod = "GET";
var opUrl = "sla_domain"; // appending this to the end of rubrikHost URL
var urlParamValues = null;
var headers = null;
var contentType = "application/json"
var content = "";

//
// Return type: CompsiteType(statusCode:string,responseString:string) - The REST response string and status code as named key-value pairs

// Create transient host and Op
var host = createHost(rubrikHost, username, password);
var op = createOp(host, opMethod, opUrl);

// Execute request
var request = setRequest(op, setUrlParamValues(urlParamValues), headers, contentType, content);
var response = request.execute();
//Process response
var responseString = parseResponse(response);
var statusCode = response.statusCode;

// Create a transient RESTHost
// If given user/password, uses Basic auth in Shared Session mode
function createHost(url, user, pw) {
	System.log("Creating transient REST host with base URL: " + url);
	
	
	var host = new RESTHost(url);
	host.name = generateNameFromUrl(url);
	host.url = url;
	host.hostVerification = false;
	host.proxyHost = null;
	host.proxyPort = 0;
	host.authentication = createSharedBasicAuth(user, pw);
	
	host = RESTHostManager.createTransientHostFrom(host);
	
	RESTHostManager.reloadConfiguration();
	
	return host;
}

// Generate a friendly name for a RESTHost or RESTOperation from a given URL,
// removing "HTTP" and "HTTPS", and replacing non-words with '_'
function generateNameFromUrl(url) {
	var name = url;
	name = name.replace(/https:\/\//i, '');
	name = name.replace(/http:\/\//i, '');
	name = name.replace(/\W/g, '_');
	return name;
}

// Instantiate REST Basic authentication in Shared Session mode
function createSharedBasicAuth(user, pw) {
	if (!isSet(user) || !isSet(pw)) {
		return null;
	}
	
	var authParams = ["Shared Session", user, pw];
	var authObject = RESTAuthenticationManager.createAuthentication("Basic", authParams);
	
	System.log("REST host authentication: " + authObject);
	
	return authObject;
}

// Is a given string non-null and not empty?
function isSet(s) {
	return s != null && s != "";
}

// Create a transient RESTOperation
// For POST and PUT, the default content type is application/json
function createOp(host, method, url) {
	var name = generateNameFromUrl(url);
	
	var op = new RESTOperation(name);
	op.method = method;
	op.urlTemplate = url;
	op.host = host;
	
	if (method.toUpperCase() === "POST" || method.toUpperCase() === "PUT") {
		op.defaultContentType = "application/json";
	}
	
	
	op = RESTHostManager.createTransientOperationFrom(op);
	
	return op;
}

// If no in-line parameter values are given, return empty array by default
function setUrlParamValues(urlParamValues) {
	return (!urlParamValues) ? [] : urlParamValues;
}

// Prepare the RESTRequest object for executing the RESTOperation
function setRequest(op, urlParamValues, headers, contentType, content) {
	var request = op.createRequest(urlParamValues, content);
	request.contentType = contentType;
	
	for each (var header in headers) {
		request.setHeader(header.key, header.value);
	}
	
	return request;
}

// Parse the RESTResponse object returned from executing a RESTOperation
function parseResponse(response) {
    const HTTP_ClientError = 404;
	var statusCode = response.statusCode;
	
	var headers = response.getAllHeaders();
	for each (var headerKey in headers.keys) {
		System.debug(headerKey + ": " + headers.get(headerKey));
	}
	
	var contentAsString = response.contentAsString;
	System.log("Response content as string: " + contentAsString);
	
	if (statusCode > HTTP_ClientError) {
	    throw "HTTPError: status code: " + statusCode;
	} else {
	    return contentAsString;
	}
}

// Make the magic happen
var jsonResponse = response.contentAsString;

var slaDomains = [];

var slas = JSON.parse(jsonResponse).data;
for each (sla in slas){
	slaDomains.push(sla.name);
	}
return slaDomains;
