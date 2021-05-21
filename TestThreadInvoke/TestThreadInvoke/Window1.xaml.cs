using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO.Ports;
using System.Threading;
using System.Windows.Threading;

namespace TestThreadInvoke
{
    /// <summary>
    /// Window1.xaml 的互動邏輯
    /// </summary>
    /// 
    public partial class Window1 : Window
    {
        static public bool _continue;
        static public SerialPort _serialPort;
        SerialPort serialPort = new SerialPort();
        string recievedData;

        private Thread readThread = null;// new Thread(Read);
        private delegate void SafeCallDelegate(string text);
        public delegate void showtext_delegate();
        private delegate void UpdateUiTextDelegate(string text);
        public Window1()
        {
            InitializeComponent();
            _serialPort = new SerialPort();
            //_serialPort.PortName = SetPortName(_serialPort.PortName);
            //_serialPort.BaudRate = SetPortBaudRate(_serialPort.BaudRate);
            //_serialPort.Parity = SetPortParity(_serialPort.Parity);
            //_serialPort.DataBits = SetPortDataBits(_serialPort.DataBits);
            //_serialPort.StopBits = SetPortStopBits(_serialPort.StopBits);
            //_serialPort.Handshake = SetPortHandshake(_serialPort.Handshake);
            foreach (string s in SerialPort.GetPortNames())
            {
                comboBox1.Items.Add(s);
                richTextBox1.AppendText("\n");
                richTextBox1.AppendText(s);
            }
            comboBox1.SelectedIndex = 0;
            //this.Dispatcher.Invoke(DispatcherPriority.Normal, new showtext_delegate(Read));
        }
        private void Window1_Loaded(object sender, RoutedEventArgs e)
        {
            //string[] ports = SerialPort.GetPortNames();
            //Console.WriteLine("The following serial ports were found:");            
            //foreach (string port in ports)
            //{
            //    //Console.WriteLine(port); // Display each port name to the console.
            //    comboBox1.Items.Add(port);
            //}
        }
        ~Window1()
        {
            //if (readThread!=null)
            //    readThread.Abort();
        }

        private void WriteTextSafe(string text)
        {
            //if (richTextBox1.InvokeRequired)
            //{
            //    var d = new SafeCallDelegate(WriteTextSafe);
            //    richTextBox1.Invoke(d, new object[] { text });
            //}
            //else
            //{
            //    richTextBox1.AppendText(text);
            //}
        }

        public void Read()
        {
            while (_continue)
            {
                try
                {
                    string message = _serialPort.ReadLine();
                    richTextBox1.AppendText(message);
                    //WriteTextSafe(message);
                    //Console.WriteLine(message);
                }
                catch (TimeoutException) { }
            }
        }
        private void DataWrited(string text)
        {
            richTextBox1.AppendText(text);
        }

        private void serialPort_DataRecieved(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            // Collecting the characters received to our 'buffer' (string).
            recievedData = serialPort.ReadExisting();

            // Delegate a function to display the received data.
            Dispatcher.Invoke(DispatcherPriority.Send, new UpdateUiTextDelegate(DataWrited), recievedData);
        }

        private void button2_Click(object sender, RoutedEventArgs e)
        {
            serialPort.PortName = comboBox1.SelectedItem.ToString();
            serialPort.BaudRate = 115200;
            serialPort.Parity = Parity.None;
            serialPort.DataBits = 8;
            serialPort.StopBits = StopBits.One;
            serialPort.Handshake = Handshake.None;
            serialPort.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(serialPort_DataRecieved);

            //_serialPort.ReadTimeout = 500;
            //_serialPort.WriteTimeout = 500;
            try 
            {
                serialPort.Open();
                serialPort.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(serialPort_DataRecieved);
                //continue = true;
                //readThread = new Thread(new ThreadStart(Read)); ;//new Thread(Read);
                //readThread.Start();
                
            }
            catch(Exception err)
            {
                System.Windows.MessageBox.Show(err.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void button3_Click(object sender, RoutedEventArgs e)
        {
            if (serialPort.IsOpen)
            {
                serialPort.Close(); // Close port.
            }
        }

        private void button4_Click(object sender, RoutedEventArgs e)
        {
            if (serialPort.IsOpen)
            {
                serialPort.Write(textBox1.Text);
            }
        }


    }
}
