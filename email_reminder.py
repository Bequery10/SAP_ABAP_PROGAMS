from datetime import datetime


def read_info_from_file(filename):
    with open(filename, "r") as f:
        lines = [line.strip() for line in f if line.strip()]
    if len(lines) < 3:
        raise ValueError(
            "Text file must have at least 3 lines: subject keywords, body keywords, and cutoff date."
        )
    subject_elements = set(lines[0].split(","))
    body_elements = set(lines[1].split(","))
    cutoff_date = datetime.strptime(lines[2], "%Y-%m-%d")
    return subject_elements, body_elements, cutoff_date
    root.mainloop()


import win32com.client
from datetime import datetime


def has_reply_from_recipient(msg, inbox, cutoff_date):
    items = inbox.Items
    items.Sort("[SentOn]", True)
    for item in items:
        if not hasattr(item, "SentOn"):
            continue
        sent_on_naive = item.SentOn.replace(tzinfo=None)
        if sent_on_naive < cutoff_date:
            break
        if hasattr(item, "ConversationID") and hasattr(msg, "ConversationID"):
            if item.ConversationID == msg.ConversationID:
                if item.SenderEmailAddress in msg.To or (
                    hasattr(msg, "CC") and item.SenderEmailAddress in msg.CC
                ):
                    return True
            elif hasattr(item, "OriginalConvoID"):
                print("Found original conversation ID")
                if msg.ConversationID == item.OriginalConvoID:
                    if item.SenderEmailAddress in msg.To or (
                        hasattr(msg, "CC") and item.SenderEmailAddress in msg.CC
                    ):
                        return True
    return False


def intersection(text, keywords):
    if not keywords or keywords == {""} or "none" in {kw.lower() for kw in keywords}:
        return False

    intersected = any(kw.strip().lower() in text.lower() for kw in keywords)
    return intersected


email_list = set()


def check_and_send(subject_elements, body_elements, cutoff_date):
    outlook = win32com.client.Dispatch("Outlook.Application")
    namespace = outlook.GetNamespace("MAPI")
    sent_items = namespace.GetDefaultFolder(5)
    inbox = namespace.GetDefaultFolder(6)

    with open("body.txt", "r") as f:
        body_text = f.read()

    # reminded_email_ids = []
    for msg in sent_items.Items:

        hatirlatma_text = "> HATIRLATMA: "
        sent_on_naive = msg.SentOn.replace(tzinfo=None)
        if (
            (
                intersection(msg.Subject, subject_elements)
                or intersection(msg.Body, body_elements)
            )
            and not intersection(msg.Subject, {hatirlatma_text})
            and sent_on_naive > cutoff_date
        ):

            if has_reply_from_recipient(msg, inbox, cutoff_date):
                continue

            forward_mail = msg.Forward()
            colon_index = msg.Subject.find(":")

            if colon_index != -1:
                new_subject = msg.Subject[colon_index + 1 :].strip()
            else:
                new_subject = msg.Subject

            forward_mail.Subject = hatirlatma_text + new_subject

            # Remove all recipients from the forwarded mail
            while forward_mail.Recipients.Count > 0:
                forward_mail.Recipients.Remove(1)
            for recipient in msg.Recipients:
                if recipient.Type == 1:  # To
                    forward_mail.Recipients.Add(recipient.Address).Type = 1
                elif recipient.Type == 2:  # CC
                    forward_mail.Recipients.Add(recipient.Address).Type = 2
                elif recipient.Type == 3:  # BCC
                    forward_mail.Recipients.Add(recipient.Address).Type = 3

            if not forward_mail.Recipients.ResolveAll():
                print(f"Çözümlenemeyen alıcı(lar) for: {msg.Subject}")
                continue

            forward_mail.UserProperties.Add("OriginalConvoID", 1, True)
            forward_mail.UserProperties("OriginalConvoID").Value = msg.ConversationID

            # reminded_email_ids.append(msg.EntryID)
            forward_mail.Send()
            recipient_addresses = [recipient.Address for recipient in msg.Recipients]
            print("Forward sent for:", msg.Subject, "to:", recipient_addresses)


if __name__ == "__main__":
    try:
        subject_elements, body_elements, cutoff_date = read_info_from_file("info.txt")
        check_and_send(subject_elements, body_elements, cutoff_date)
        print("Email reminder process completed.")
    except Exception as e:
        import traceback

        tb = traceback.extract_tb(e.__traceback__)
        if tb:
            line = tb[-1].lineno
            print(f"Error on line {line}: {e}")
        else:
            print("Error:", e)
