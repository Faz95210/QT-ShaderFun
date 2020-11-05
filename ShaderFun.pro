TEMPLATE = subdirs

SUBDIRS = \
Cv2Qml \
app

Cv2Qml.subdir = Cv2Qml
app.subdir = app

app.depends = Cv2Qml
