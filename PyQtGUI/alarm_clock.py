#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from PyQt4.QtGui import *
from PyQt4.QtCore import *
from time import strftime
import time, datetime
from subprocess import check_output


ALARMS_CNT = 7
WR_TIME_CMD = 0
TMP_FILE = "tmp"

class runTclThread( QThread ):

    def __init__(self, tcl_cmd):
      QThread.__init__(self)
      self.tcl_cmd = tcl_cmd

    def __del__(self):
        self.wait( )

    def run( self ):
      out = check_output( self.tcl_cmd + "; exit 0",
      stderr=STDOUT. shell=True)
      self.emit( SIGNAL('cmd_done(QString)'), out ) 


def get_set_time_cmd( posix_time, cur_time_en ):
  tcl_cmd = "quartus_stp -t set_time.tcl " + str( WR_TIME_CMD )
  if( cur_time_en == False ):
    tcl_cmd = tcl_cmd + " " + str( posix_time )
  return tcl_cmd

def write_time_to_fpga( posix_time, cur_time_en ):
  return -1

def write_alarms_to_fpga( _alarms_nums, _alarms_times ):
  tcl_cmd = "quartus_stp -t set_alarms.tcl "
  for i in _alarms_nums:
    tcl_cmd += str(i) + str(_alarms_times[i]) + " "

  return -1

class WrTimeDialog( QDialog ):
  def __init__(self, parent=None):
    super(WrTimeDialog, self).__init__(parent)
    self.setGeometry( 40,40,500,600)
    self.setWindowTitle( "Writing time" )

    self.buttonBox = QDialogButtonBox(self)
    self.buttonBox.setOrientation( Qt.Horizontal )
    self.buttonBox.setStandardButtons( QDialogButtonBox.Cancel )
    self.buttonBox.clicked.connect( self.dialogClose  )

    self.textBrowser = QTextBrowser(self)
    self.textBrowser.append("Start writing time to FPGA...")

    global user_time
    global cur_time_en

    set_time_cmd = get_set_time_cmd( user_time, cur_time_en )

    self.textBrowser.append( set_time_cmd )

    self.get_thread = runTclThread( set_time_cmd )
    self.get_thread.start()
    self.connect(self.get_thread, SIGNAL("cmd_done(QString)"), self.addOutput )

    self.verticalLayout = QVBoxLayout(self)
    self.verticalLayout.addWidget(self.textBrowser)
    self.verticalLayout.addWidget(self.buttonBox)

  def addOutput( self, output ):
    self.textBrowser.append( output )

  def dialogClose( self ):
    self.done( 0) 


class WrAlarmDialog( QDialog ):
  def __init__(self, parent=None):
      super(WrAlarmDialog, self).__init__(parent)

      self.buttonBox = QDialogButtonBox(self)
      self.buttonBox.setOrientation( Qt.Horizontal )
      self.buttonBox.setStandardButtons( QDialogButtonBox.Cancel )

      self.textBrowser = QTextBrowser(self)
      self.textBrowser.append("Start writing time to FPGA...")

      self.verticalLayout = QVBoxLayout(self)
      self.verticalLayout.addWidget(self.textBrowser)
      self.verticalLayout.addWidget(self.buttonBox)
     
      global alarms_cnt
      global alarms_numbers
      global alarms_times


class MainWindow( QWidget ):
    def __init__(self):
      super( MainWindow, self).__init__()

      self.setGeometry( 1, 1, 800, 800 )
      self.setWindowTitle( 'Alarm Clock' )
      self.setWindowIcon( QIcon( 'alarm.png' ) )

      self.lcd = QLCDNumber(self)
      self.lcd.setFixedSize(300, 200)
      self.lcd.setDigitCount(8)
      self.digTime()

      self.date = QCalendarWidget( self )
      self.date.setSizePolicy(QSizePolicy.Maximum,QSizePolicy.Maximum)
      #self.date.setFixedWidth(380) 
      self.date.setEnabled( False )

      self.dateedit = QDateTimeEdit( self )
      self.dateedit.setDateTime(QDateTime.currentDateTime())
      self.dateedit.setCalendarPopup(True)
      self.dateedit.setSizePolicy(QSizePolicy.Minimum,QSizePolicy.Minimum)
      self.dateedit.setFixedSize( 450, 70)

      self.alarms_chb = list()
      self.alarms_dateedit = list()

      for i in xrange( ALARMS_CNT ):
          name = "Alarm # " + str( i+1 ) 
          self.alarms_chb.append( QCheckBox( name ) )
          alarms_dateedit_t = QDateTimeEdit( self )
          alarms_dateedit_t.setDateTime(QDateTime.currentDateTime())
          alarms_dateedit_t.setCalendarPopup(True)
          alarms_dateedit_t.setSizePolicy(QSizePolicy.Minimum,QSizePolicy.Minimum)
          self.alarms_dateedit.append( alarms_dateedit_t ) 

      self.cur_time  = QRadioButton("Currrent time")
      self.cust_time = QRadioButton("Custom time")
      self.connect(self.cur_time, SIGNAL("clicked()"), self.enCustTimeEditBox )
      self.connect(self.cust_time, SIGNAL("clicked()"), self.enCustTimeEditBox )

      self.enCustTimeEditBox()

      self.initUI()  
  
    def initUI( self ):
      self.setLayoyt()

    def titleLable( self ):
      font = QFont()
      font.setPointSize(32);
      font.setBold( True );

      title = QLabel('FPGA Alarm Clock And Time Control', self)
      title.setFont(font);
      title.setAlignment(Qt.AlignCenter|Qt.AlignHCenter)
      return title

    def setTimeLable( self ):
      font = QFont()
      font.setPointSize(20);
      title = QLabel('Set time', self)
      title.setFont(font);
      return title

    def setAlarmLable( self ): 
      font = QFont()
      font.setPointSize(20);
      title = QLabel('Set alarms', self)
      title.setFont(font);
      return title

    def vLine( self ):
      vline = QFrame( self )
      vline.setFrameShape(QFrame.HLine);
      vline.setFrameShadow(QFrame.Sunken);
      vline.setSizePolicy(QSizePolicy.Expanding,QSizePolicy.Expanding)
      return vline

    def setTopLayout( self ):
      layout = QVBoxLayout()
      layout.addWidget( self.titleLable() )
      layout.addWidget( self.vLine() )
      return layout

    def setTimeLayout( self ):
      layout = QVBoxLayout()
      layout.addWidget( self.setTimeLable() )
      layout.addWidget( self.rbSetTime() )
      layout.addLayout( self.mainSetTimeLayout() )
      layout.addWidget( self.vLine() )
      return layout

    def setAlarmLayout( self ):
      layout = QVBoxLayout()
      layout.addWidget( self.setAlarmLable() )
      layout.addLayout( self.mainAlarmLayout() )
      layout.addWidget( self.vLine() )
      return layout

    def setExitLayout( self ):
      layout = QVBoxLayout()
      hbox = QHBoxLayout()
      hbox.addStretch( 1 )
      hbox.addWidget( self.exitButton()  )

      layout.addStretch(1)
      layout.addLayout(hbox)

      return layout

    def rbSetTime( self ):
      groupBox = QGroupBox()
      self.cur_time.setChecked(True)
      layout = QHBoxLayout()
      layout.addWidget( self.cur_time )
      layout.addWidget( self.cust_time )
      layout.addStretch(1)
      groupBox.setLayout( layout )

      return groupBox

    def mainSetTimeLayout( self ):
      layout_all = QVBoxLayout()

      layout_tmp = QHBoxLayout()
      layout_tmp.addWidget( self.curTimeLable() )
      layout_tmp.addStretch(1)
      layout_tmp.addWidget( self.date )
      layout_tmp.addStretch(1)
      layout_tmp.addWidget( self.lcd )
      layout_tmp.addStretch(1)

      layout_all.addLayout( layout_tmp )
      layout_all.addStretch(1)

      layout_tmp = QHBoxLayout()
      layout_tmp.addWidget( self.custTimeLable() )
      layout_tmp.addStretch(1)
      layout_tmp.addWidget( self.dateedit )
      layout_tmp.addStretch(1)

      layout_all.addLayout( layout_tmp )

      layout_all.addStretch(1)
      layout_all.addWidget( self.applyTimeButton() )
      layout_all.addStretch(1)

      return layout_all


    def mainAlarmLayout( self ):
      widget = QWidget()
      widget.setFixedSize(300,300)

      tablelayout = QGridLayout()
      for i in xrange( ALARMS_CNT ):
        pic = QLabel( self )
        pic.setFixedSize( 20, 20)
        pic.setPixmap( QPixmap("alarm_ic.png") )

        tablelayout.addWidget( pic, i , 0 )
        tablelayout.addWidget( self.alarms_chb[i], i, 1 )
        tablelayout.addWidget( self.alarms_dateedit[i], i, 2 )

      widget.setLayout(tablelayout)
      scroll = QScrollArea()
      scroll.setFixedHeight(200)
      scroll.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOn)
      scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
      scroll.setWidgetResizable(False)
      scroll.setWidget(widget)
      layout = QVBoxLayout()
      layout.addWidget( scroll )

      layout.addStretch(1)
      layout.addWidget( self.applyAlarmButton() )
      layout.addStretch(1)

      return layout

    def digTime( self ):
      timer = QTimer(self)
      timer.timeout.connect(self.Time)
      timer.start(10)


    def Time(self):
      self.lcd.display(strftime("%H"+":"+"%M"+":"+"%S"))

    def curTimeLable( self ):
      lable = QLabel('Current time:', self)
      return lable

    def custTimeLable( self ):
      lable = QLabel('Custom time:', self)
      return lable

    def enCustTimeEditBox( self ):
      if( self.cust_time.isChecked() ):
        cust_time_en = True
      else:
        cust_time_en = False
      self.dateedit.setEnabled( cust_time_en )

    def applyTimeButton( self ):
      btn = QPushButton('Write time', self)
      btn.setToolTip('Write current time settings to FPGA')
      btn.resize( btn.sizeHint() )
      self.connect( btn, SIGNAL("clicked()"), self.wrTime )
      return btn

    def applyAlarmButton( self ):
      btn = QPushButton('Write alarms', self)
      btn.setToolTip('Write alarms settings to FPGA')
      btn.resize( btn.sizeHint() )
      self.connect( btn, SIGNAL("clicked()"), self.wrAlarm )
      return btn

    def exitButton( self ):
      btn = QPushButton('Exit', self)
      btn.setToolTip('Press to exit')
      btn.clicked.connect( self.clickExit )
      btn.resize( btn.sizeHint() )

      return btn

    def clickExit( self ):
      result = QMessageBox.question( self, 'Message', "Are You sure? No changes will apply.", QMessageBox.Yes | QMessageBox.No)

      if result == QMessageBox.Yes:
        exit()

    def setLayoyt( self ):
      main_layout = QVBoxLayout()
      main_layout.addLayout( self.setTopLayout() ) 
      main_layout.addLayout( self.setTimeLayout() )
      main_layout.addLayout( self.setAlarmLayout() )
      main_layout.addLayout( self.setExitLayout() )
      main_layout.addStretch( 1 )
      self.setLayout( main_layout )

    def wrTime( self ):
      global user_time
      global cur_time_en
      cur_time_en = False

      qt_time = self.dateedit.dateTime()

      if( self.cur_time.isChecked() ):
        cur_time_en = True

      py_time = qt_time.toPyDateTime()

      user_time = int( time.mktime( py_time.timetuple()) )    
 
      dialogTextBrowser = WrTimeDialog( self )
      dialogTextBrowser.exec_()


    def wrAlarm( self ):
      global alarms_cnt
      global alarms_numbers
      global alarms_times

      alarms_cnt = 0
      alarms_times = list()
      alarms_numbers = list()

      for i in xrange( ALARMS_CNT ):
        alarms_times.append( False )
        if( self.alarms_chb[i].isChecked() ):
          alarms_cnt += 1
          alarms_numbers.append(i)

          qt_time = self.alarms_dateedit[i].dateTime()
          py_time = qt_time.toPyDateTime()
          alarm_time = int( time.mktime( py_time.timetuple()) )    
          alarms_times[i] = alarm_time 
          
      if( alarms_cnt == 0 ):
        result = QMessageBox.question( self, 'Message', "No alarms set.", QMessageBox.Ok)
      else:
        dialogWrAlarms = WrAlarmDialog( self )
        dialogWrAlarms.exec_()
  
#####################################
# Create an PyQT4 application object. 
######################################

app = QApplication(sys.argv)       
main = MainWindow()
 
main.show()
sys.exit(app.exec_())
