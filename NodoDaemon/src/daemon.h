#ifndef DAEMON_H
#define DAEMON_H

#include <QObject>
#include <QtDBus/QDBusConnection>
#include <QTimer>
#include <QHostAddress>
#include <QNetworkInterface>
#include "PowerKeyThread.h"
#include "RecoveryKeyThread.h"
#include "ServiceManagerThread.h"
#include "nodo_dbus_adaptor.h"

class Daemon : public QObject
{
    Q_OBJECT
public:
    Daemon();

public slots:
    void startRecovery(int recoverFS, int rsyncBlockchain);
    void changeServiceStatus(QString operation, QString service);
    void restart(void);
    void shutdown(void);
    void setBacklightLevel(int backlightLevel);
    int getBacklightLevel(void);

    void setPassword(QString pw);
    int getBlockchainStorageStatus(void);
    void factoryResetApproved(void);

signals:
    void startRecoveryNotification(const QString &message);
    void serviceManagerNotification(const QString &message);
    void serviceStatusReadyNotification(const QString &message);
    void passwordChangeStatus(int status);

    void factoryResetStarted(void);
    void factoryResetRequested(void);
    void factoryResetCompleted(void);
    void powerButtonPressDetected(void);
    void powerButtonReleaseDetected(void);
    void hardwareStatusReadyNotification(const QString &message);

private:
    int m_prevIdleTime = 0;
    int m_prevTotalTime = 0;
    double m_CPUUsage = 0;
    double m_AverageCPUFreq = 0;
    double m_RAMUsage = 0;
    double m_TotalRAM = 0;
    double m_CPUTemperature = 0;
    double m_blockChainStorageUsed = 0;
    double m_blockChainStorageTotal = 0;
    double m_systemStorageUsed = 0;
    double m_systemStorageTotal = 0;
    double m_GPUUsage = 0;
    double m_maxGPUFreq = 0;
    double m_currentGPUFreq = 0;

    QString m_hardwareStatus;

    QTimer *m_hardwareStatusTimer;
    QTimer *m_serviceStatusTimer;

    PowerKeyThread *powerKeyThread;
    RecoveryKeyThread *recoveryKeyThread;



    void readCPUUsage(void);
    void readAverageCPUFreq(void);
    void readRAMUsage(void);
    void readCPUTemperature(void);
    void readGPUUsage(void);
    void readMaxGPUSpeed(void);
    void readCurrentGPUSpeed(void);
    void readBlockchainStorageUsage(void);
    void readSystemStorageUsage(void);

private slots:
    void updateHardwareStatus(void);
    void updateServiceStatus(void);
    void serviceStatusReceived(const QString &message);
};

#endif // DAEMON_H
