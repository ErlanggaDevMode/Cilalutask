import React, { useState } from 'react';
import { X, Download, FileSpreadsheet, FileText, Check } from 'lucide-react';
import { Task, SOPDocument, Company } from '../../types';
import { CURRENT_COMPANY, INITIAL_TASKS, INITIAL_SOPS } from '../../data/mockData';

interface ExportReportModalProps {
  isOpen: boolean;
  onClose: () => void;
  tasks?: Task[];
  sops?: SOPDocument[];
  company?: Company;
  period?: string;
  onExportSuccess?: (message: string) => void;
}

function sanitizeCsvCell(val: string): string {
  let cleaned = val.replace(/\r?\n/g, ' ').trim();
  if (cleaned.length > 0 && '=+-@\t\r'.includes(cleaned[0])) {
    cleaned = `'${cleaned}`;
  }
  return `"${cleaned.replace(/"/g, '""')}"`;
}

function escapeXml(val: string): string {
  return val
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function buildPdfDocument(title: string, subtitle: string, lines: string[]): string {
  const cleanPdf = (s: string) =>
    s
      .replace(/[^\x20-\x7E]/g, '')
      .replace(/\\/g, '\\\\')
      .replace(/\(/g, '\\(')
      .replace(/\)/g, '\\)');

  const streamLines: string[] = [
    '0.0 0.14 0.44 rg',
    '40 765 515 48 re f',
    'BT',
    '1 1 1 rg',
    '/F2 13 Tf',
    '52 792 Td',
    `(${cleanPdf(title)}) Tj`,
    '/F1 9 Tf',
    '0 -16 Td',
    `(${cleanPdf(subtitle)}) Tj`,
    'ET',
    'BT',
    '0.05 0.11 0.19 rg',
    '44 740 Td',
  ];

  for (const line of lines.slice(0, 42)) {
    const isHeader = line.startsWith('[') || line.startsWith('===');
    streamLines.push(isHeader ? '/F2 10 Tf' : '/F1 9.5 Tf');
    streamLines.push(`(${cleanPdf(line)}) Tj`);
    streamLines.push('0 -15.5 Td');
  }
  streamLines.push('ET');

  const contentStream = streamLines.join('\n');
  const objects = [
    '1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj',
    '2 0 obj\n<< /Type /Pages /Kids [6 0 R] /Count 1 >>\nendobj',
    '3 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj',
    '4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj',
    `5 0 obj\n<< /Length ${contentStream.length} >>\nstream\n${contentStream}\nendstream\nendobj`,
    '6 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents 5 0 R >>\nendobj',
  ];

  let pdf = '%PDF-1.4\n';
  const offsets: number[] = [];
  for (const obj of objects) {
    offsets.push(pdf.length);
    pdf += obj + '\n';
  }
  const xrefPos = pdf.length;
  pdf += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`;
  for (const off of offsets) {
    pdf += `${String(off).padStart(10, '0')} 00000 n \n`;
  }
  pdf += `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefPos}\n%%EOF`;

  return pdf;
}

export const ExportReportModal: React.FC<ExportReportModalProps> = ({
  isOpen,
  onClose,
  tasks = INITIAL_TASKS,
  sops = INITIAL_SOPS,
  company = CURRENT_COMPANY,
  period = 'Periode Berjalan',
  onExportSuccess,
}) => {
  const [format, setFormat] = useState<'pdf' | 'csv' | 'xlsx'>('pdf');
  const [divisionFilter, setDivisionFilter] = useState<string>('Semua Divisi');
  const [exported, setExported] = useState(false);

  if (!isOpen) return null;

  const filteredTasks =
    divisionFilter === 'Semua Divisi'
      ? tasks
      : tasks.filter((t) =>
          t.division.toLowerCase().includes(divisionFilter.replace(' & Tech', '').toLowerCase())
        );

  const total = filteredTasks.length;
  const completed = filteredTasks.filter((t) => t.status === 'Selesai' || t.progressPercent >= 100).length;
  const inProgress = filteredTasks.filter((t) => t.status === 'Dalam Proses').length;
  const notStarted = filteredTasks.filter((t) => t.status === 'Belum Dimulai').length;
  const completionRate = total > 0 ? ((completed / total) * 100).toFixed(1) : '0.0';

  const triggerDownload = (blob: Blob, filename: string) => {
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  };

  const handleExport = () => {
    setExported(true);
    const safeCode = company.code.replace(/[^a-zA-Z0-9_-]/g, '_');

    if (format === 'csv') {
      const rows: string[][] = [
        ['LAPORAN KINERJA EKSEKUTIF', company.name, company.code],
        ['Periode', period, 'Filter Divisi', divisionFilter],
        [],
        ['RINGKASAN METRIK', 'Nilai'],
        ['Total Tugas', String(total)],
        ['Tugas Selesai', `${completed} (${completionRate}%)`],
        ['Dalam Proses', String(inProgress)],
        ['Belum Dimulai', String(notStarted)],
        [],
        ['ID Tugas', 'Judul Tugas', 'Divisi', 'Penanggung Jawab', 'Prioritas', 'Status', 'Progres', 'Batas Waktu'],
        ...filteredTasks.map((t) => [
          t.id,
          t.title,
          t.division,
          t.assignee.name,
          t.priority,
          t.status,
          `${t.progressPercent}%`,
          t.deadlineLabel,
        ]),
      ];
      const csvText = '\uFEFF' + rows.map((r) => r.map(sanitizeCsvCell).join(',')).join('\r\n');
      triggerDownload(new Blob([csvText], { type: 'text/csv;charset=utf-8;' }), `Laporan_Kinerja_${safeCode}.csv`);
    } else if (format === 'xlsx') {
      const xmlRows = filteredTasks
        .map(
          (t) =>
            `<Row><Cell><Data ss:Type="String">${escapeXml(t.id)}</Data></Cell><Cell><Data ss:Type="String">${escapeXml(t.title)}</Data></Cell><Cell><Data ss:Type="String">${escapeXml(t.division)}</Data></Cell><Cell><Data ss:Type="String">${escapeXml(t.assignee.name)}</Data></Cell><Cell><Data ss:Type="String">${escapeXml(t.status)}</Data></Cell><Cell><Data ss:Type="String">${t.progressPercent}%</Data></Cell></Row>`
        )
        .join('');
      const xml = `<?xml version="1.0" encoding="UTF-8"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"><Worksheet ss:Name="Laporan Kinerja"><Table><Row><Cell><Data ss:Type="String">LAPORAN KINERJA ${escapeXml(company.name)} (${escapeXml(company.code)})</Data></Cell></Row><Row><Cell><Data ss:Type="String">Total Tugas: ${total} | Selesai: ${completed} (${completionRate}%)</Data></Cell></Row><Row><Cell><Data ss:Type="String">ID Tugas</Data></Cell><Cell><Data ss:Type="String">Judul</Data></Cell><Cell><Data ss:Type="String">Divisi</Data></Cell><Cell><Data ss:Type="String">PIC</Data></Cell><Cell><Data ss:Type="String">Status</Data></Cell><Cell><Data ss:Type="String">Progres</Data></Cell></Row>${xmlRows}</Table></Worksheet></Workbook>`;
      triggerDownload(new Blob([xml], { type: 'application/vnd.ms-excel' }), `Laporan_Kinerja_${safeCode}.xls`);
    } else {
      const lines = [
        '====================================================',
        `Perusahaan : ${company.name} (${company.code})`,
        `Periode    : ${period} | Divisi: ${divisionFilter}`,
        '====================================================',
        '[1] RINGKASAN EKSEKUTIF',
        `- Total Tugas       : ${total} Tugas`,
        `- Tugas Selesai     : ${completed} Tugas (${completionRate}%)`,
        `- Dalam Proses      : ${inProgress} Tugas`,
        `- Belum Dimulai     : ${notStarted} Tugas`,
        '',
        '[2] DAFTAR TUGAS OPERASIONAL',
        ...filteredTasks.map(
          (t) => `- [${t.status}] ${t.title} | ${t.division} | PIC: ${t.assignee.name} (${t.progressPercent}%)`
        ),
        '',
        `[3] KEPATUHAN SOP (${sops.length} Dokumen Aktif)`,
        ...sops.map((s) => `- ${s.code} (${s.version}): ${s.title}`),
      ];
      const pdfContent = buildPdfDocument(
        `LAPORAN KINERJA EKSEKUTIF - ${company.name}`,
        `Periode: ${period} | Divisi: ${divisionFilter}`,
        lines
      );
      triggerDownload(new Blob([pdfContent], { type: 'application/pdf' }), `Laporan_Kinerja_${safeCode}.pdf`);
    }

    setTimeout(() => {
      setExported(false);
      onExportSuccess?.(`Laporan kinerja (${format.toUpperCase()}) berhasil diunduh!`);
      onClose();
    }, 500);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-md bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Download className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Ekspor Laporan Kinerja</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-5 space-y-4">
          <p className="text-xs text-slate-600 leading-relaxed">
            Unduh rekapitulasi data tingkat penyelesaian tugas ({completed}/{total} selesai —{' '}
            <strong>{completionRate}%</strong>), SLA divisi, dan skor karyawan untuk{' '}
            <strong>{period}</strong>.
          </p>

          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Cakupan Divisi</label>
            <select
              value={divisionFilter}
              onChange={(e) => setDivisionFilter(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 bg-white focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            >
              <option value="Semua Divisi">Semua Divisi</option>
              <option value="Operasional">Operasional</option>
              <option value="IT & Tech">IT & Tech</option>
              <option value="Pemasaran">Pemasaran</option>
              <option value="Finance & Akuntansi">Finance & Akuntansi</option>
            </select>
          </div>

          <div className="space-y-2">
            <label className="text-xs font-bold text-slate-700">Pilih Format Berkas</label>
            <div className="grid grid-cols-3 gap-2">
              <button
                type="button"
                onClick={() => setFormat('pdf')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'pdf'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileText className="w-5 h-5" />
                <span className="text-xs">PDF Eksekutif</span>
              </button>

              <button
                type="button"
                onClick={() => setFormat('xlsx')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'xlsx'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileSpreadsheet className="w-5 h-5 text-emerald-600" />
                <span className="text-xs">Excel XLSX</span>
              </button>

              <button
                type="button"
                onClick={() => setFormat('csv')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'csv'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileText className="w-5 h-5 text-slate-500" />
                <span className="text-xs">CSV Data</span>
              </button>
            </div>
          </div>

          <div className="pt-2 flex items-center gap-2">
            <button
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Batal
            </button>
            <button
              onClick={handleExport}
              disabled={exported}
              className="flex-1 py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
            >
              {exported ? (
                <>
                  <Check className="w-4 h-4 stroke-[3]" />
                  <span>Mengunduh...</span>
                </>
              ) : (
                <>
                  <Download className="w-4 h-4" />
                  <span>Unduh Berkas</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
