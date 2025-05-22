import requests
from sys                import exit
from PySide6.QtCore     import Qt, QEvent,QAbstractListModel,QModelIndex
from PySide6.QtWidgets  import QApplication,QMainWindow,QMessageBox
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot

class request_item_t():
    def __init__(self,method,url,params,data,json,headers,status,text):
        self.method = method
        self.url = url
        self.params = params
        self.data = data
        self.json = json
        self.headers = headers
        self.status = status
        self.text = text

class file_model_t(QAbstractListModel):
    UrlRole = Qt.UserRole + 1
    ParamsRole = Qt.UserRole + 2
    DataRole = Qt.UserRole + 3
    JsonRole = Qt.UserRole + 4
    HeadersRole = Qt.UserRole + 5
    StatusRole = Qt.UserRole + 6
    TextRole = Qt.UserRole + 7
    MethodRole = Qt.UserRole + 8

    def __init__(self):
        super().__init__()
        self._requests = []
    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < len(self._requests)):
            return None

        item = self._requests[index.row()]

        if role == self.UrlRole:
            return item.url
        elif role == self.ParamsRole:
            return item.params
        elif role == self.DataRole:
            return item.data
        elif role == self.JsonRole:
            return item.json
        elif role == self.HeadersRole:
            return item.headers
        elif role == self.StatusRole:
            return item.status
        elif role == self.TextRole:
            return item.text
        elif role == self.MethodRole:
            return item.method
        return None

    def roleNames(self):
        return {
            self.MethodRole: b'method',
            self.UrlRole: b'url',
            self.ParamsRole: b'params',
            self.DataRole: b'DATA',
            self.JsonRole: b'json',
            self.HeadersRole: b'headers',
            self.StatusRole: b'status',
            self.TextRole: b'text',
        }

    def rowCount(self, parent=QModelIndex()):
        return len(self._requests)

    def rowCount(self, parent=QModelIndex()):
        return len(self._requests)

    def insert(self, method,url, params, data, json, headers, status,text):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._requests.append(request_item_t(method,url, params, data, json, headers, status,text))
        self.endInsertRows()

    def delete(self, index):
        if(index < 0 or index >= len(self._requests)):
            return
        self.beginRemoveRows(QModelIndex(), index, index)
        del self._requests[index]
        self.endRemoveRows()

class backend_t(QObject):
    def __init__(self,model):
        super().__init__()
        self.model = model


    @Slot(str,str,str,str,str,str)
    def send_request(self,method,url,params,data,json,headers):
        try:        
            r = requests.request(method,url,params = params,data = data,json = json,headers = headers)
            self.model.insert(method,url,params,data,json,headers,r.status_code,r.text)
        except Exception as e:
            self.info_message_box(str(e))

    @Slot(str)
    def info_message_box(self,text):
        msg_box = QMessageBox()
        msg_box.setIcon(QMessageBox.Information)
        msg_box.setWindowTitle("Requester")
        msg_box.setText(text)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.exec()

    @Slot(str,int)
    def export(self,file,item):
        item = self.model._requests[item]
        with open(file[8:],"w") as f:
            f.write(f"""METHOD:{item.method}\nURL:{item.url}\nSTATUS:{item.status}\nPARAMS:{item.params}\n
                DATA:{item.data}\nJSON:{item.json}\nHEADERS:{item.headers}\nTEXT:{item.text}""")
           
   
if __name__ == "__main__":

    app = QApplication()
    engine = QQmlApplicationEngine()
    file_model = file_model_t()
    backend = backend_t(file_model)
    
    ctx = engine.rootContext()
    ctx.setContextProperty("backend", backend)
    ctx.setContextProperty("file_model", file_model)

    engine.load("components/main.qml")

    if not engine.rootObjects():
        exit(-1)
    exit(app.exec())
  



