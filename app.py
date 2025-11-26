from flask import Flask, render_template, request, redirect
from database import get_connection
from datetime import date

app = Flask(__name__)


def add_log(emp_id, action):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO admin_log (emp_id, action) VALUES (%s, %s)",
        (emp_id, action)
    )
    conn.commit()
    cursor.close()
    conn.close()

@app.route("/", methods=["GET", "POST"])
def home():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST" and request.form.get("form_type") == "add_employee":
        emp_id = request.form["emp_id"]
        first = request.form["first_name"]
        last = request.form["last_name"]
        dept_id = request.form["dept_id"]
        desig_id = request.form["desig_id"]
        email = request.form["email"]
        gender = request.form["gender"]
        hire_date = request.form["hire_date"]

        cursor.execute("""
            INSERT INTO employee(emp_id, first_name, last_name, dept_id, desig_id, email, hire_date, gender)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (emp_id, first, last, dept_id, desig_id, email, hire_date, gender))
        conn.commit()

        add_log(emp_id, "Employee added")

   
    if request.method == "POST" and request.form.get("form_type") == "add_attendance":
        emp_id = request.form["emp_id"]
        att_date = request.form["att_date"]
        working_hrs = request.form["working_hrs"]
        status = request.form["status"]

        cursor.execute("""
            INSERT INTO attendance(emp_id, att_date, working_hrs, status)
            VALUES (%s, %s, %s, %s)
        """, (emp_id, att_date, working_hrs, status))
        conn.commit()

        add_log(emp_id, "Attendance marked")

 
    if request.method == "POST" and request.form.get("form_type") == "generate_payroll":
        month = request.form["month"]
        total_days = int(request.form["total_days"])
        cursor.callproc('generate_payroll', [month, total_days, date.today()])
        conn.commit()

        add_log(None, "Payroll generated")

    cursor.execute("SELECT * FROM employee")
    employees = cursor.fetchall()

    cursor.execute("SELECT * FROM payroll")
    payrolls = cursor.fetchall()

    cursor.execute("SELECT * FROM leave_record")
    leaves = cursor.fetchall()

    cursor.execute("SELECT * FROM admin_log ORDER BY log_time DESC")
    logs = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "index.html",
        employees=employees,
        payrolls=payrolls,
        leaves=leaves,
        logs=logs
    )


@app.route("/approve_leave/<int:leave_id>")
def approve_leave(leave_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.callproc("approve_leave", (leave_id,))
    conn.commit()

    add_log(None, f"Leave approved (leave_id={leave_id})")

    cursor.close()
    conn.close()
    return redirect("/") 


@app.route("/reject_leave/<int:leave_id>")
def reject_leave(leave_id):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "UPDATE leave_record SET status='rejected' WHERE leave_id=%s",
        (leave_id,)
    )
    conn.commit()

    add_log(None, f"Leave rejected (leave_id={leave_id})")

    cursor.close()
    conn.close()
    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)
