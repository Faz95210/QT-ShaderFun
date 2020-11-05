#include <QDir>
#include <QDebug>
#include <QTimer>

#include "includes/ShaderManager.h"
#include "includes/Config.h"


ShaderManager::ShaderManager(QObject *parent) : QObject(parent)
{
    QDir recoredDir(SHADER_DIRECTORY_PATH);
    QStringList allFiles = recoredDir.entryList(QDir::NoDotAndDotDot | QDir::System | QDir::Files, QDir::DirsFirst);//(QDir::Filter::Files,QDir::SortFlag::NoSort)
    for (auto &file: allFiles){
        this->m_shaders.push_back(file.split(".")[0]);
    }
    if (!this->m_shaders.isEmpty()){
        QFile file(SHADER_DIRECTORY_PATH + m_shaders.front() + ".fsh");
        if (file.open(QFile::ReadOnly)){
            m_code = file.readAll();
            setCode(m_code);
        } else {
            qDebug() << "couldn't  open " << SHADER_DIRECTORY_PATH + m_shaders.front() + ".fsh";
        }
    } else {
        this->m_shaders.push_back("");
    }
    m_timer.start();
    QTimer *timer = new QTimer(this);
    connect(timer,
            &QTimer::timeout,
            this,
            &ShaderManager::updateTimer);
    timer->start(100);
}

void ShaderManager::changeShader(QString shaderName){
    m_code.clear();
    QFile file(SHADER_DIRECTORY_PATH + shaderName + ".fsh");
    if (file.open(QFile::ReadOnly)){
        qDebug() << "getting code from " << SHADER_DIRECTORY_PATH + shaderName + ".fsh";
        m_code = file.readAll();
        setCode(m_code);
    } else {
        qDebug() << "couldn't  open " << SHADER_DIRECTORY_PATH + shaderName + ".fsh";
    }
}

void ShaderManager::save(QString code)
{
    QString fileName = code.split('\n')[0];
    QFile file(SHADER_DIRECTORY_PATH + fileName);
    if (file.open(QFile::ReadWrite | QFile::Truncate)) {
        file.write(code.toUtf8());
    }
}

QString ShaderManager::code() const
{
    return m_code;
}

void ShaderManager::setU_time(float timer)
{
    Q_UNUSED(timer);
    m_u_time = (m_timer.elapsed());
    emit u_timeChanged(m_u_time);
}

void ShaderManager::setCode(QString code)
{
    if (m_code == code)
        return;

    m_code = code;
    emit codeChanged(m_code);
}

float ShaderManager::u_time() const
{
    return m_u_time;
}

bool ShaderManager::updateTimer(){
    setU_time();
}

void ShaderManager::setShaders(QStringList shaders)
{
    if (m_shaders == shaders)
        return;

    m_shaders = shaders;
    emit shadersChanged(m_shaders);
}

QStringList ShaderManager::shaders() const
{
    return m_shaders;
}
