#ifndef PIXMAPIMAGE_H
#define PIXMAPIMAGE_H

#include <QQuickPaintedItem>
#include <QPainter>
#include "pixmapcontainer.h"

class PixmapImage : public QQuickPaintedItem
{
    Q_OBJECT
public:
    PixmapImage(QQuickItem *parent = Q_NULLPTR);
    Q_INVOKABLE void setImage(QObject *pixmapContainer);

protected:
    virtual void paint(QPainter *painter) Q_DECL_OVERRIDE;

private:
    PixmapContainer m_pixmapContainer;

};

#endif // PIXMAPIMAGE_H
