using System;
using System.Xml.Serialization;

namespace PBDotNetInterface.Contacts
{
    /// <remarks/>
    [Serializable()]
    public partial class DocumentElement
    {
        private DocumentElementContacts[] itemsField;
        [System.Xml.Serialization.XmlElementAttribute("contacts", Form = System.Xml.Schema.XmlSchemaForm.Unqualified)]
        public DocumentElementContacts[] Items
        {
            get
            {
                return this.itemsField;
            }
            set
            {
                this.itemsField = value;
            }
        }
    }

    [Serializable()]
    public partial class DocumentElementContacts
    {
        private string shortNameField;
        private string emailField;

        /// <remarks/>
        public string shortName
        {
            get
            {
                return this.shortNameField;
            }
            set
            {
                this.shortNameField = value;
            }
        }

        /// <remarks/>
        public string email
        {
            get
            {
                return this.emailField;
            }
            set
            {
                this.emailField = value;
            }
        }
    }
}