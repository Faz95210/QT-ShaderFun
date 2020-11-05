#ifndef SHADERMANAGER_H
#define SHADERMANAGER_H

#include <QElapsedTimer>
#include <QObject>
#include <QDebug>

class ShaderManager : public QObject
{
    Q_OBJECT
    QStringList m_shaders = {};

    QString m_code;
    QElapsedTimer m_timer;

    float m_u_time;

private:
public:
    ShaderManager(QObject *parent = nullptr);
    Q_INVOKABLE void changeShader(QString);
    Q_INVOKABLE void save(QString);

    Q_PROPERTY(float u_time READ u_time WRITE setU_time NOTIFY u_timeChanged)

    Q_PROPERTY(QStringList shaders READ shaders WRITE setShaders NOTIFY shadersChanged)

    Q_PROPERTY(QString code READ code WRITE setCode NOTIFY codeChanged)

    QStringList shaders() const;

    QString code() const;

    float u_time() const;

signals:

    void shadersChanged(QStringList shaders);

    void codeChanged(QString code);

    void u_timeChanged(float u_time);

public slots:

    bool updateTimer();

    void setShaders(QStringList shaders);
    void setCode(QString code);

    void setU_time(float timer = 0);
};

#endif // SHADERMANAGER_H
