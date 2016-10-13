import tornado.ioloop
import tornado.httpserver
import tornado.web
import tornado.websocket
import socket

clients = []


class WebSocketHandler(tornado.websocket.WebSocketHandler):

    def open(self, *args):
        print ("New connection")
        clients.append(self)

    def on_message(self, message):
        print 'Message received'
        print message
        for client in clients:
            client.write_message(message)

    def data_received(self, chunk):
        pass

    def on_close(self):
        clients.remove(self)

    def check_origin(self, origin):
        return True

app = tornado.web.Application([(r'/chat', WebSocketHandler)])

if __name__ == "__main__":
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(8888)
    myIP = socket.gethostbyname(socket.gethostname())
    print '*** Websocket Server Started at %s***' % myIP
    tornado.ioloop.IOLoop.instance().start()
