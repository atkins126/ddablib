object DemoForm: TDemoForm
  Left = 275
  Top = 109
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Message Dialog Components Demo'
  ClientHeight = 471
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object tabCtrl: TTabControl
    Left = 0
    Top = 0
    Width = 817
    Height = 471
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'TPJWinMsgDlg'
      'TPJVCLMsgDlg')
    TabIndex = 0
    OnChange = tabCtrlChange
    object lblAlign: TLabel
      Left = 10
      Top = 39
      Width = 30
      Height = 15
      Caption = 'Align:'
      FocusControl = cbAlign
    end
    object lblOffsetLeft: TLabel
      Left = 98
      Top = 69
      Width = 55
      Height = 15
      Caption = 'OffsetLeft:'
      FocusControl = edOffsetLeft
    end
    object lblOffsetTop: TLabel
      Left = 226
      Top = 69
      Width = 55
      Height = 15
      Caption = 'OffsetTop:'
      FocusControl = edOffsetTop
    end
    object lblButtonGroup: TLabel
      Left = 10
      Top = 108
      Width = 72
      Height = 15
      Caption = 'ButtonGroup:'
      FocusControl = cbButtonGroup
    end
    object lblButtons: TLabel
      Left = 10
      Top = 148
      Width = 45
      Height = 15
      Caption = 'Buttons:'
      FocusControl = lbButtons
    end
    object lblDefButton: TLabel
      Left = 10
      Top = 276
      Width = 57
      Height = 15
      Caption = 'DefButton:'
      FocusControl = cbDefButton
    end
    object lblHelpContext: TLabel
      Left = 10
      Top = 315
      Width = 70
      Height = 15
      Caption = 'HelpContext:'
    end
    object lblIconKind: TLabel
      Left = 414
      Top = 39
      Width = 51
      Height = 15
      Caption = 'IconKind:'
      FocusControl = cbIconKind
    end
    object lblIconResource: TLabel
      Left = 414
      Top = 79
      Width = 80
      Height = 15
      Caption = 'IconResource:'
      FocusControl = cbIconResource
    end
    object lblKind: TLabel
      Left = 414
      Top = 118
      Width = 28
      Height = 15
      Caption = 'Kind:'
      FocusControl = cbKind
    end
    object lblMakeSound: TLabel
      Left = 414
      Top = 158
      Width = 68
      Height = 15
      Caption = 'MakeSound:'
      FocusControl = chkMakeSound
    end
    object lblOptions: TLabel
      Left = 414
      Top = 187
      Width = 46
      Height = 15
      Caption = 'Options:'
      FocusControl = lbOptions
    end
    object lblText: TLabel
      Left = 414
      Top = 256
      Width = 24
      Height = 15
      Caption = 'Text:'
      FocusControl = edText
    end
    object lblTitle: TLabel
      Left = 414
      Top = 335
      Width = 26
      Height = 15
      Caption = 'Title:'
      FocusControl = edText
    end
    object bvlVertical: TBevel
      Left = 394
      Top = 34
      Width = 2
      Height = 382
    end
    object cbAlign: TComboBox
      Left = 98
      Top = 39
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 0
    end
    object edOffsetLeft: TEdit
      Left = 167
      Top = 69
      Width = 51
      Height = 23
      TabOrder = 1
      OnKeyPress = edNumKeyPress
    end
    object edOffsetTop: TEdit
      Left = 295
      Top = 69
      Width = 51
      Height = 23
      TabOrder = 2
    end
    object btnExecute: TButton
      Left = 20
      Top = 423
      Width = 641
      Height = 41
      Caption = 'Store Properties && Execute'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 16
      OnClick = btnExecuteClick
    end
    object cbButtonGroup: TComboBox
      Left = 98
      Top = 108
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 3
      OnChange = cbButtonGroupChange
    end
    object lbButtons: TCheckListBox
      Left = 98
      Top = 148
      Width = 179
      Height = 119
      OnClickCheck = lbButtonsClickCheck
      ItemHeight = 15
      TabOrder = 4
    end
    object cbDefButton: TComboBox
      Left = 98
      Top = 276
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 5
    end
    object cbIconKind: TComboBox
      Left = 502
      Top = 39
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 8
    end
    object cbIconResource: TComboBox
      Left = 502
      Top = 79
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 9
      Items.Strings = (
        '<empty string>'
        'GREENCIRCLE'
        '#678'
        'INVALID_NAME'
        'MAINICON')
    end
    object cbKind: TComboBox
      Left = 502
      Top = 118
      Width = 179
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 10
    end
    object chkMakeSound: TCheckBox
      Left = 502
      Top = 158
      Width = 120
      Height = 20
      TabOrder = 11
    end
    object lbOptions: TCheckListBox
      Left = 502
      Top = 187
      Width = 179
      Height = 55
      OnClickCheck = lbOptionsClickCheck
      ItemHeight = 15
      TabOrder = 12
    end
    object edText: TMemo
      Left = 502
      Top = 256
      Width = 307
      Height = 60
      ScrollBars = ssBoth
      TabOrder = 13
      WordWrap = False
    end
    object edTitle: TEdit
      Left = 502
      Top = 335
      Width = 307
      Height = 23
      TabOrder = 14
    end
    object cbHelpContext: TComboBox
      Left = 98
      Top = 315
      Width = 71
      Height = 23
      ItemHeight = 15
      TabOrder = 6
      OnKeyPress = edNumKeyPress
      Items.Strings = (
        '1'
        '2')
    end
    object btnHelp: TButton
      Left = 679
      Top = 423
      Width = 130
      Height = 41
      Caption = 'Help'
      TabOrder = 17
      OnClick = btnHelpClick
    end
    object chkHelpEvent: TCheckBox
      Left = 98
      Top = 394
      Width = 199
      Height = 21
      Caption = 'Use OnHelp event handler'
      TabOrder = 7
    end
    object chkCustomise: TCheckBox
      Left = 502
      Top = 374
      Width = 307
      Height = 21
      Caption = 'Customise dialog using OnShow and OnHide'
      TabOrder = 15
    end
  end
  object dlgWinMsg: TPJWinMsgDlg
    IconResource = 'fred'
    Left = 408
    Top = 344
  end
  object dlgVCLMsg: TPJVCLMsgDlg
    Left = 440
    Top = 344
  end
  object dlgVCLDummy: TPJVCLMsgDlg
    Left = 472
    Top = 344
  end
end
