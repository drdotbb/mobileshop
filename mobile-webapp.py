from flask import Flask, redirect, url_for, render_template , request

from flask_mysqldb import MySQL


app = Flask(__name__)

app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']='rootroot'
app.config['MYSQL_DB']='mobilerepair'
app.config['MYSQL_CURSORCLASS']= 'DictCursor'

mysql=MySQL(app)

#owner inputted variables
customer_id=0
estimate='0 Days'
fixable='null'
delete_id=0


customerIDQuery=''' SELECT customer.customerID FROM customer,gives WHERE
customer.customerID=gives.customerID AND gives.emailTrackingUrl='{}' '''

customerQuery=''' SELECT firstName,lastName,address,email,phone FROM customer WHERE customerID={} '''

deviceQuery=''' SELECT device.model,device.manufacturer,device.imeiNumber FROM device,customer,gives
    WHERE device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''

staffQuery=''' SELECT staff.firstName, staff.lastName, staff.staffID FROM staff,fixes,device,gives,customer
    WHERE staff.staffID=fixes.staffID AND fixes.imeiNumber=device.imeiNumber 
    AND device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''

issueQuery=''' SELECT issue.issueDescription,issue.issueType,issue.fixable,issue.estimatedFixTime FROM issue,device,gives,customer
    WHERE issue.imeiNumber=device.imeiNumber 
    AND device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''


updateFixTimeQuery=''' UPDATE issue 
    JOIN device ON issue.imeiNumber=device.imeiNumber
    JOIN gives ON device.imeiNumber=gives.imeiNumber
    JOIN customer ON gives.customerID=customer.customerID
    SET issue.estimatedFixTime=%s
    WHERE customer.customerID=%s '''

updateFixableQuery=''' UPDATE issue 
    JOIN device ON issue.imeiNumber=device.imeiNumber
    JOIN gives ON device.imeiNumber=gives.imeiNumber
    JOIN customer ON gives.customerID=customer.customerID
    SET issue.fixable=%s
    WHERE customer.customerID=%s '''


deleteCustomerQuery=''' DELETE Customer,Gives,Device FROM Customer 
JOIN Gives ON Customer.customerID=Gives.customerID
JOIN Device ON Gives.imeiNumber=Device.ImeiNumber
WHERE Customer.customerID={} '''

avgCostQuery=''' SELECT AVG(issue.cost) FROM issue '''

usersPerManufacturerQuery=''' SELECT manufacturer, COUNT(*)
    FROM device,customer,gives
    WHERE device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID
    GROUP BY manufacturer '''


resourcefulStaffQuery=''' SELECT A.staffID
    FROM Staff A
    WHERE NOT EXISTS
        (SELECT I.productID
        FROM Inventory I
        WHERE I.productID NOT IN
            (SELECT U.productID
            FROM mobRep.use U
            WHERE U.staffID=A.staffID)) '''

#get customerID
def getCustomerID(name):
    cur=mysql.connection.cursor()
    cur.execute(customerIDQuery.format(name))
    results=cur.fetchall()
    return results

#get info on a customer
def getCustomerInfo(customerID):
    cur=mysql.connection.cursor()
    cur.execute(customerQuery.format(customerID))
    results=cur.fetchall()
    return results

#get info on a customers device
def getDeviceInfo(customerID):
    cur=mysql.connection.cursor()
    cur.execute(deviceQuery.format(customerID))
    results=cur.fetchall()
    return results

#get info on the staff member working on a customers device
def getStaffInfo(customerID):
    cur=mysql.connection.cursor()
    cur.execute(staffQuery.format(customerID))
    results=cur.fetchall()
    return results

#get info on a customers issue
def getIssueInfo(customerID):
    cur=mysql.connection.cursor()
    cur.execute(issueQuery.format(customerID))
    results=cur.fetchall()
    return results

#update the estimated issue fix time for a customer (update + join)
def updateFixTime():
    cur=mysql.connection.cursor()
    cur.execute(updateFixTimeQuery, (estimate,customer_id))
    mysql.connection.commit()

#update wether an issue is fixable or not (update)
def updateFixable():
    cur=mysql.connection.cursor()
    cur.execute(updateFixableQuery, (fixable,customer_id))
    mysql.connection.commit()

#deletes a customer query (+ their device) given their customerID (delete + cascade)
def deleteCustomer():
    #print("delete:",delete_id)
    cur=mysql.connection.cursor()
    cur.execute(deleteCustomerQuery.format(delete_id))
    mysql.connection.commit()


#check the avg. issue cost across all customers (aggregation)
def getAvgCost():
    cur=mysql.connection.cursor()
    cur.execute(avgCostQuery)
    mysql.connection.commit()
    results=cur.fetchall()
    return results

#get the number of customer with a device from each manufacturer (aggregation + group-by)
def getUsersPerManufacturer():
    cur=mysql.connection.cursor()
    cur.execute(usersPerManufacturerQuery)
    mysql.connection.commit()
    results=cur.fetchall()
    return results

#find all the staff that use all the product in inventory (divison: NOT EXISTS - NOT IN query)
def getResourcefulStaff():
    cur=mysql.connection.cursor()
    cur.execute(resourcefulStaffQuery)
    mysql.connection.commit()
    results=cur.fetchall()
    return results









@app.route("/")
@app.route("/track",methods = ['POST', 'GET'])
def track():
    #global customer_trackingid
    #global customerID

    if request.method == 'POST':
        customer_trackingid=request.form['tracking']
        #print(customer_trackingid)
        return redirect(url_for('home',name=customer_trackingid))
    
    else:

        return render_template("track.html")








        
@app.route('/status/<name>')
def home(name):

    #get customer ID
    customerID=getCustomerID(name)
    subCustomerID=customerID[0]
    myCustomerID=[*subCustomerID.values()]
    myIntCustomerID=myCustomerID[0]
    
    customerInfo=getCustomerInfo(myIntCustomerID)
    myCustomerInfo=[*customerInfo[0].values()]
    #print(customerInfo)
    fn=myCustomerInfo[0]
    ln=myCustomerInfo[1]

    deviceInfo=getDeviceInfo(myIntCustomerID)
    myDeviceInfo=[*deviceInfo[0].values()]
    #print(deviceInfo)
    device=myDeviceInfo[0]
    deviceNumber=myDeviceInfo[2]

    staffInfo=getStaffInfo(myIntCustomerID)
    myStaffInfo=[*staffInfo[0].values()]
    #print(staffInfo)
    staffID=myStaffInfo[0]

    issueInfo=getIssueInfo(myIntCustomerID)
    myIssueInfo=[*issueInfo[0].values()]
    #print(issueInfo)
    issueDescription=myIssueInfo[0]
    issueFixTime=myIssueInfo[3]


    customerKeys = (

        "First Name",
        "Last Name",
        "Device",
        "Device Number",
        "Staff ID",
        "Issue Decription",
        
    )
    customerValues = (
    
        fn,
        ln,
        device,
        deviceNumber,
        staffID,
        issueDescription,
        
    )
    customer = [
        (customerKeys[i], customerValues[i]) for i, _ in enumerate(customerKeys)
    ]
    return render_template("status.html", customer=customer, steps=[1, 1, 1, 0], url=name,
    cusID=myIntCustomerID, issueFixTime=issueFixTime)


        







@app.route("/update",methods = ['POST', 'GET'])
def shop_update():
    global customer_id 
    global estimate 
    global fixable 
    global delete_id

    if request.method == 'POST':
        customer_id = request.form['id']
        estimate = request.form['fixtime']
        fixable = request.form['fixable']
        delete_id=request.form['del-id']

        updateFixTime()
        updateFixable()
        deleteCustomer()

        #avg cost of device
        avgCost=getAvgCost()
        print(avgCost)

        #number of users with devices for each different manufacturer
        usersPerManufacturer=getUsersPerManufacturer()
        print(usersPerManufacturer)

        #find all the staff that use all the product in inventory
        resourcefulStaff=getResourcefulStaff()
        print(resourcefulStaff)

        return render_template("update.html") 
    
    else:
        customer_id = request.args.get('id')
        customer_id = request.args.get('fixtime')
        customer_id = request.args.get('fixable')
        customer_id = request.args.get('del-id')
        return render_template("update.html") 
  












@app.route("/contact", methods=['POST','GET'])
def comtact():
    if request.method == 'POST':
        contact_fname = request.form['fname']
        contact_lname = request.form['lname']
        contact_email = request.form['email']
        contact_city=request.form['city']
        contact_state = request.form['state']
        contact_feedback = request.form['feedback']

        #get customer info + feedback
        print(contact_fname)
        print(contact_lname)
        print(contact_email)
        print(contact_city)
        print(contact_state)
        print(contact_feedback)

        return render_template("contact.html") 
        

    else:
        return render_template("contact.html") 
   





if __name__ == "__main__":
    app.run(debug=True)
