using System;
using System.Xml.Serialization;

[Serializable()]
public partial class DocumentElement {
    
    private DocumentElementEmailSettings[] itemsField;
    [System.Xml.Serialization.XmlElementAttribute("emailSettings", Form = System.Xml.Schema.XmlSchemaForm.Unqualified)]
    public DocumentElementEmailSettings[] Items {
        get {
            return this.itemsField;
        }
        set {
            this.itemsField = value;
        }
    }
}

[Serializable()]
public partial class DocumentElementEmailSettings {
    
    private string keyField;
    
    private string valueField;
    public string key {
        get {
            return this.keyField;
        }
        set {
            this.keyField = value;
        }
    }
    public string value {
        get {
            return this.valueField;
        }
        set {
            this.valueField = value;
        }
    }
}
