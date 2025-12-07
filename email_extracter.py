from docx import Document
import os
import re
import requests
import time
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


def fetch_emails(folder_path):
    all_emails = set()
    for filename in os.listdir(folder_path):
        if filename.endswith(".docx"):
            emails = fetch_emails_helper(os.path.join(folder_path, filename))
            all_emails.update(emails)
    return all_emails


def fetch_emails_helper(file_name):
    doc = Document(file_name)
    text = "\n".join([para.text for para in doc.paragraphs])
    emails = re.findall(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+", text)
    return set(emails)


EMAIL_HOST = "smtp.office365.com"
EMAIL_PORT = 587
EMAIL_USER = "sas@mitasindustry.com"
email_password_part1 = "*****"
email_password_part2 = "*****"
EMAIL_PASSWORD = email_password_part1 + email_password_part2


def send_email(emails):
    print("Sending email notification...")

    for email in emails:
        try:
            RECIPIENT_EMAIL = email

            msg = MIMEMultipart()
            msg["From"] = EMAIL_USER
            msg["To"] = RECIPIENT_EMAIL

            msg["Subject"] = "Mitas endustri, geri bildirim"
            body = "merhaba, mesajinizi bekiyoruz."

            msg.attach(MIMEText(body, "plain"))

            # Use Office 365 SMTP settings
            server = smtplib.SMTP("smtp.office365.com", 587)
            server.starttls()  # Enable TLS encryption
            server.login(EMAIL_USER, EMAIL_PASSWORD)

            # Send email
            text = msg.as_string()
            server.sendmail(EMAIL_USER, RECIPIENT_EMAIL, text)
            server.quit()

            print(f"Email sent successfully to {RECIPIENT_EMAIL}")

        except Exception as e:
            print(f"Failed to send email: {e}")


if __name__ == "__main__":
    emails = fetch_emails("files_with_emails")
    send_email(emails)
