using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        DataSet dt = new DataSet();
        DataTable dtb = new DataTable();
        DataTable dtb2 = new DataTable();
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            dtb=dt.Tables.Add("Button1");
            dtb.Columns.Add(new DataColumn("Selected",typeof(bool)));
            dtb.Columns.Add(new DataColumn("NET",typeof(string)));
            dtb.Columns.Add(new DataColumn("ID",typeof(string)));
            dtb.Columns.Add(new DataColumn("FILE",typeof(string)));
            dtb.Columns.Add(new DataColumn("PATH",typeof(string)));
            dtb.Columns.Add(new DataColumn("5",typeof(string)));
            dtb.Columns.Add(new DataColumn("6",typeof(string)));
            DataRow row;
            //string a="FILE_A";
            //char[] c=a.ToCharArray();
            //byte[] b = Encoding.ASCII.GetBytes(c);
            
            /*int j=0;
            
            for(int i = 0; i <= 4; i ++)
            {
                row = dtb.NewRow();
                row["Selected"] = true;
                row["Selected"] = true;
                row["ID"] = (i+1000).ToString();
                string a = "FILE_A";
                char[] c = a.ToCharArray();
                byte[] b = Encoding.ASCII.GetBytes(c);
                b[b.Length - 1] += (byte)i;
                j = 0;
                foreach(byte b1 in b)
                {
                    c[j]=Convert.ToChar(b1);
                    j++;
                }
                row["FILE"] = new string(c);
                string path = "C://test1";
                char[] pathc = path.ToCharArray();
                byte[] pathb = Encoding.ASCII.GetBytes(pathc);
                pathb[pathb.Length - 1] += (byte)i;
                j=0;
                foreach(byte b1 in pathb)
                {
                    pathc[j]=Convert.ToChar(b1);
                    j++;
                }
                row["PATH"] = new string(pathc);
                row["5"] = "Item " + (i + 4).ToString();
                row["6"] = "Item " + (i + 5).ToString();
                dtb.Rows.Add(row);
            }*/
            //
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET1"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);

            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1001).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1002).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_A"; row["PATH"] = "c:\\Test1"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_B"; row["PATH"] = "c:\\Test2"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_C"; row["PATH"] = "c:\\Test3"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_D"; row["PATH"] = "c:\\Test4"; dtb.Rows.Add(row);
            row = dtb.NewRow(); row["Selected"] = true; row["NET"] = "NET2"; row["ID"] = (1003).ToString(); row["FILE"] = "FILE_E"; row["PATH"] = "c:\\Test5"; dtb.Rows.Add(row);
            //
            /*
            for (int i = 0; i <= 4; i++)
            {
                row = dtb.NewRow();
                row["Selected"] = true;
                row["NET"] = "NET2";
                row["ID"] = (i + 1000).ToString();
                string a = "FILE_A";
                char[] c = a.ToCharArray();
                byte[] b = Encoding.ASCII.GetBytes(c);
                b[b.Length - 1] += (byte)i;
                j = 0;
                foreach (byte b1 in b)
                {
                    c[j] = Convert.ToChar(b1);
                    j++;
                }
                row["FILE"] = new string(c);
                string path = "C://test10";
                char[] pathc = path.ToCharArray();
                byte[] pathb = Encoding.ASCII.GetBytes(pathc);
                pathb[pathb.Length - 1] += (byte)i;
                j = 0;
                foreach (byte b1 in pathb)
                {
                    pathc[j] = Convert.ToChar(b1);
                    j++;
                }
                row["PATH"] = new string(pathc);
                row["5"] = "Item " + (i + 4).ToString();
                row["6"] = "Item " + (i + 5).ToString();
                dtb.Rows.Add(row);
            }*/
                    
            dataGridView1.DataSource=dtb;

        }

        private void button2_Click(object sender, EventArgs e)
        {
            //dtb2 = dtb.Copy();
            //dtb2.Clear();
            //DataRow[] rows=dtb.Select("ID=1001","NET ASC, FILE ASC");
            string[] fileseq = { "_E", "_B", "_C"};
            DataView dtv = new DataView();
            EnumerableRowCollection<DataRow> query =
               //from Button1 in dtb.AsEnumerable()
               from order in dtb.AsEnumerable()
               where order.Field<string>("ID") == "1001" && order.Field<string>("FILE") != "FILE_A" && order.Field<string>("FILE") != "FILE_D"
               orderby order.Field<string>("NET")
               select order;
           
            DataView view = query.AsDataView();
            DataTable table_sorted = view.ToTable();
            DataRow[] test = new DataRow[table_sorted.Rows.Count];
            int i=0;
            DataTable tableview = new DataTable("test");
            tableview = dtb.Copy();
            tableview.Clear();
            foreach(DataRow r in table_sorted.Rows)
                tableview.Rows.Add(table_sorted.Rows[table_sorted.Rows.Count - 1 - i]);
            
            //DataRow[] SelectDows = dtb.Select("ID = 1001");

            dataGridView2.DataSource = tableview;// table_sorted;
            //view.Sort = "FILE";
            //DataTable showtable=view.ToTable("1001");
            //foreach (DataRow row in showtable.Rows)
            //{
            //    richTextBox1.AppendText("\n"+row["PATH"]);
            //    
            //}
        }

        private void button3_Click(object sender, EventArgs e)
        {
            DataView dtv = new DataView();
            EnumerableRowCollection<DataRow> query =
                from Button1 in dtb.AsEnumerable()
                where Button1.Field<string>("ID") == "1001"
                orderby Button1.Field<string>("NET")
                select Button1;

            DataView view = query.AsDataView();

            dataGridView2.DataSource = view;
            DataTable showtable = view.ToTable("1001");
            foreach (DataRow row in showtable.Rows)
            {
                if (row["Selected"].Equals(true))
                {
                    richTextBox1.AppendText("\nBUTTON3: " + row["PATH"]);
                }

            }
        }
    }
}
