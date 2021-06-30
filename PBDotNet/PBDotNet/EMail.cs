using System;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.IO;
using System.Xml.Serialization;
using System.Xml.Linq;
using System.Collections.Generic;

namespace PBDotNetInterface
{
    class EMail
    {
        public string Host { get; set; }
        public string From { get; set; }
        public string FromName { get; set; }
        public string FromPassword { get; set; }
        public int Port { get; set; }
        public string Subject { get; set; }
        public string RegardsText { get; set; }
        public StringBuilder Body { get; set; }
        public string To { get; set; }

        public EMail(string to, string mailSetting, string subject, string mailMessage)
        {
            LoadMailSetting(mailSetting,mailMessage);
            To = to;
            this.Subject = subject;// string.Format("{0}. {1}", this.Subject, subject);
        }

        public void SendMail()
        {
            var smtp = new SmtpClient()
            {
                Host = this.Host,
                Port = this.Port,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(this.From, this.FromPassword)
            };
            MailAddress fromAddress = new MailAddress(this.From, this.FromName);
            using (var message = new MailMessage(this.From, this.To)
            {
                Subject = this.Subject,
                Body = this.Body.ToString(),
                IsBodyHtml = true,
                From = fromAddress
            })
                smtp.Send(message);
            smtp.Dispose();
        }

        private void LoadMailSetting(string mailSetting,string message)
        {
            XDocument xSetting = XDocument.Parse(mailSetting);
            XElement xSettingRoot = xSetting.Root;

            Dictionary<string, string> settings = new Dictionary<string, string>();
            xSettingRoot.Elements().ToList<XElement>().ForEach(
                x =>
                {
                    settings.Add(x.Element("settingkey").Value, x.Element("settingvalue").Value);
                }
                );

            Host = settings["host"];// xRoot.Element("host").Value;
            Port = int.Parse(settings["port"]);
            From = settings["from"];
            FromName = settings["fromName"];
            FromPassword = settings["fromPassword"];
            Subject = settings["subject"];
            RegardsText = settings["regardsText"];

            XDocument xMessage = XDocument.Parse(message);
            XElement xMessageRoot = xMessage.Root;

            SetMailBody(xMessageRoot, settings);

        }

        public void SetMailBody(XElement root, Dictionary<string, string> settings)
        {
            string tableStyle = " style = 'font-family: verdana,arial,sans-serif;font-size:12px;color:#333333;border-width: 5px;border-color: #666666;border-collapse: collapse;padding:8px;'";
            string tdStyle = " style='border-width: 1px;padding: 8px;border-style: solid;border-color: #666666;background-color: #ffffff;'";
            string tdStyleRightAlligned = " style='text-align:right;color:blue; border-width: 1px;padding: 8px;border-style: solid;border-color: #666666;background-color: #ffffff;'";
            string thStyle = " style='border-width: 1px;padding: 8px;border-style: solid;border-color: #666666;background-color: #dedede;'";

            StringBuilder html = new StringBuilder("<input type='hidden' name='s' value='<br>'><p></p><table" + tableStyle + " border='1'>");
            StringBuilder htmlRow;

            if (root.Name.ToString().Equals("order", StringComparison.OrdinalIgnoreCase))
            {
                Body = new StringBuilder(settings["orderBody"]);
                html.Append(string.Format(@"<tr><th {0}>Item</th><th {0}>Brand</th><th {0}>Model</th><th {0}>Order</th><th {0}>Remarks</th></tr>", thStyle));
                foreach (var ele in root.Elements())
                {
                    htmlRow = new StringBuilder(string.Format("<tr><td {0}>Item</td><td {0}>Brand</td><td {0}>Model</td><td {1}>Order</td><td {1}>Remarks</td></tr>", tdStyle, tdStyleRightAlligned));
                    html.Append(htmlRow
                        .Replace("Item", ele.Element("item").Value)
                        .Replace("Brand", ele.Element("brand").Value)
                        .Replace("Model", ele.Element("model").Value)
                        .Replace("Order", ele.Element("order").Value)
                        .Replace("Remarks", ele.Element("remarks").Value)
                        .ToString());
                }
            }
            else if (root.Name.ToString().Equals("d_stock", StringComparison.OrdinalIgnoreCase))
            {
                Body = new StringBuilder(settings["stockBody"]);
                html.Append(string.Format(@"<tr><th {0}>Item</th><th {0}>Brand</th><th {0}>Model</th><th {0}>Stock</th></tr>", thStyle));
                foreach (var ele in root.Elements())
                {
                    htmlRow = new StringBuilder(string.Format("<tr><td {0}>Item</td><td {0}>Brand</td><td {0}>Model</td><td {1}>Stock</td></tr>", tdStyle, tdStyleRightAlligned));
                    html.Append(htmlRow
                        .Replace("Item", ele.Element("item").Value)
                        .Replace("Brand", ele.Element("brand").Value)
                        .Replace("Model", ele.Element("model").Value)
                        .Replace("Stock", ele.Element("stock").Value)
                        .ToString());
                }
            }

            html.Append("</table>");
            html.Append("</br></br>" + RegardsText);
            Body.Append(html);
        }
    }
}
