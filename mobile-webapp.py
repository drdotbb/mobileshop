from flask import Flask, redirect, url_for, render_template , request

from flask_mysqldb import MySQL


app = Flask(__name__)

app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']='rootroot'
app.config['MYSQL_DB']='mobilerepair'
app.config['MYSQL_CURSORCLASS']= 'DictCursor'

mysql=MySQL(app)

customerID=101
customerQuery=''' SELECT firstName,lastName FROM customer WHERE customerID={} '''.format(customerID)

deviceQuery=''' SELECT device.model,device.manufacturer FROM device,customer,gives
    WHERE device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''.format(customerID)

staffQuery=''' SELECT staff.firstName, staff.lastName, staff.staffID FROM staff,fixes,device,gives,customer
    WHERE staff.staffID=fixes.staffID AND fixes.imeiNumber=device.imeiNumber 
    AND device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''.format(customerID)

issueQuery=''' SELECT issue.issueDescription,issue.issueType,issue.fixable,issue.estimatedFixTime FROM issue,device,gives,customer
    WHERE issue.imeiNumber=device.imeiNumber 
    AND device.imeiNumber=gives.imeiNumber AND gives.customerID=customer.customerID 
    AND customer.customerID={} '''.format(customerID)


newFixTime='4 Days'
updateFixTimeQuery=''' UPDATE issue 
    JOIN device ON issue.imeiNumber=device.imeiNumber
    JOIN gives ON device.imeiNumber=gives.imeiNumber
    JOIN customer ON gives.customerID=customer.customerID
    SET issue.estimatedFixTime=%s
    WHERE customer.customerID=%s '''

newFixable='yes'
updateFixableQuery=''' UPDATE issue 
    JOIN device ON issue.imeiNumber=device.imeiNumber
    JOIN gives ON device.imeiNumber=gives.imeiNumber
    JOIN customer ON gives.customerID=customer.customerID
    SET issue.fixable=%s
    WHERE customer.customerID=%s '''




def getCustomerInfo():
    cur=mysql.connection.cursor()
    cur.execute(customerQuery)
    results=cur.fetchall()
    return results

def getDeviceInfo():
    cur=mysql.connection.cursor()
    cur.execute(deviceQuery)
    results=cur.fetchall()
    return results

def getStaffInfo():
    cur=mysql.connection.cursor()
    cur.execute(staffQuery)
    results=cur.fetchall()
    return results

def getIssueInfo():
    cur=mysql.connection.cursor()
    cur.execute(issueQuery)
    results=cur.fetchall()
    return results

#update + join
def updateFixTime():
    cur=mysql.connection.cursor()
    cur.execute(updateFixTimeQuery, (newFixTime,customerID))
    mysql.connection.commit()

#update
def updateFixable():
    cur=mysql.connection.cursor()
    cur.execute(updateFixableQuery, (newFixable,customerID))
    mysql.connection.commit()


@app.route("/")
@app.route("/track",methods = ['POST', 'GET'])
def track():
    if request.method == 'POST':
        customer_trackingid=request.form['tracking']
        print(customer_trackingid)
        return redirect(url_for('home',name=customer_trackingid))
    
    else:

        return render_template("track.html")

        
@app.route('/status/<name>')
def home(name):
    customerKeys = (
        
        "firstName",
        "lastName",
        "address",
        "email",
        "phone",
        "staffID",
        
        "ReferenceNumber",
        
    )
    customerValues = (
    
        "brad",
        "bak",
        "203 north rd",
        "brad@gmail.com",
        "778-222-8497",
        1,
        
        "100",
        
    )
    customer = [
        (customerKeys[i], customerValues[i]) for i, _ in enumerate(customerKeys)
    ]
    return render_template("status.html", customer=customer, steps=[1, 1, 1, 0], url=name)


        

@app.route("/update",methods = ['POST', 'GET'])
def shop_update():


    if request.method == 'POST':
        customer_id = request.form['id']
        estimate = request.form['fixtime']
        fixable = request.form['fixable']
        delete_id=request.form['del-id']
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
        return render_template("contact.html") 
        

    else:
        return render_template("contact.html") 
   





if __name__ == "__main__":
    app.run(debug=True)
