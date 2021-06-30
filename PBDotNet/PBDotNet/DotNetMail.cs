using System;
using System.Xml.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Net.Mail;
using System.Windows.Forms;

namespace PBDotNetInterface
{
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("PBDotNetInterface.DotNetMail")]
    public class DotNetMail
    {
        public void SendMail(string to, string mailSetting, string mailMessage,string subject, ref string status)
        {
            try
            {
                if (string.IsNullOrEmpty(to) || string.IsNullOrEmpty(mailSetting) || string.IsNullOrEmpty(mailMessage))
                {
                    throw new Exception("There is something wrong with email settings or email address or email message. The mail could not be sent.");
                }
                EMail mail = new EMail(to,mailSetting,subject, mailMessage);
                mail.SendMail();
                status = "OK";
            }
            catch (Exception ex)
            {
                status = ex.Message;
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
