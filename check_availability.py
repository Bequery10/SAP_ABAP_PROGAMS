import requests
import time
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

email_pass1 = "*****"  # password's first part
email_pass2 = "*****"  # password's second part
EMAIL_HOST = "smtp.office365.com"
EMAIL_PORT = 587
EMAIL_USER = "sas@mitasindustry.com"
EMAIL_PASSWORD = email_pass1 + email_pass2
RECIPIENT_EMAIL = "berkan.gokgoz@tedu.edu.tr"


def send_email(url, statuse_code=None):
    try:
        # Create messages
        msg = MIMEMultipart()
        msg["From"] = EMAIL_USER
        msg["To"] = RECIPIENT_EMAIL

        if statuse_code:
            msg["Subject"] = f"{url} Availability Alert - Status Code: {statuse_code}"
            body = (
                f"{url} is currently returning the error status code: {statuse_code}."
            )
        else:
            msg["Subject"] = f"{url} Availability Alert - Website Unreachable"
            body = f"{url} is currently unreachable"

        msg.attach(MIMEText(body, "plain"))

        # Use Office 365 SMTP settings
        server = smtplib.SMTP("smtp.office365.com", 587)
        server.starttls()  # Enable TLS encryption
        server.login(EMAIL_USER, EMAIL_PASSWORD)

        # Send email
        text = msg.as_string()
        server.sendmail(EMAIL_USER, RECIPIENT_EMAIL, text)
        server.quit()

    except Exception as e:
        raise Exception(f"Failed to send email: {e}")


def check_for_availability(url):

    try:
        response = requests.get(url)
        if response.status_code == 200:
            pass
        elif response.status_code >= 400 and response.status_code <= 600:
            send_email(url, response.status_code)
        else:
            print(f"Received status code: {response.status_code}")
            send_email(url, response.status_code)
    except requests.exceptions.RequestException as e:
        send_email(url)
    except Exception as e:
        send_email(url)


if __name__ == "__main__":

    url = "https://sas.mitasindustriy.com"
    check_for_availability(url)
