// Builds Phase1_Group102.docx from pandoc's JSON. Usage: node build.js doc.json imageDir logo.png out.docx
const fs=require('fs'),path=require('path');
const D=require('docx');
const {Document,Packer,Paragraph,TextRun,ImageRun,Table,TableRow,TableCell,WidthType,BorderStyle,ShadingType,AlignmentType,HeadingLevel,Header,Footer,PageNumber,NumberFormat,TableOfContents,LevelFormat,TableLayoutType,VerticalAlign,SimpleField,SectionType,LineRuleType}=D;
const VC=D.VerticalAlignSection||VerticalAlign;
const [,,jsonPath,imgDir,logo,out]=process.argv;
const ast=JSON.parse(fs.readFileSync(jsonPath,'utf8'));
const FONT='Times New Roman',TW=9026; // A4 with 2.54 cm margins
const WORDS=['Zero','One','Two','Three','Four','Five'];
const inl=(xs,f={})=>{const r=[];for(const x of xs||[]){switch(x.t){
  case 'Str':r.push(new TextRun({text:x.c,...f}));break;
  case 'Space':case 'SoftBreak':r.push(new TextRun({text:' ',...f}));break;
  case 'LineBreak':r.push(new TextRun({break:1,...f}));break;
  case 'Strong':r.push(...inl(x.c,{...f,bold:true}));break;
  case 'Emph':r.push(...inl(x.c,{...f,italics:true}));break;
  case 'Code':r.push(new TextRun({text:x.c[1],...f,font:'Courier New',size:f.size?f.size-1:21}));break;
  case 'Quoted':r.push(new TextRun({text:x.c[0].t==='DoubleQuote'?'\u201c':'\u2018',...f}),...inl(x.c[1],f),new TextRun({text:x.c[0].t==='DoubleQuote'?'\u201d':'\u2019',...f}));break;
  case 'Link':case 'Span':r.push(...inl(x.t==='Link'?x.c[1]:x.c[1],f));break;
  case 'RawInline':case 'Note':break;
  default:throw new Error('inline '+x.t);}}return r;};
const text=xs=>(xs||[]).map(x=>x.t==='Str'?x.c:x.t==='Code'?x.c[1]:(x.t==='Space'||x.t==='SoftBreak')?' ':x.c&&Array.isArray(x.c)?text(x.c.flat().filter(y=>y&&y.t)):'').join('');
const pngSize=f=>{const b=fs.readFileSync(f);return [b.readUInt32BE(16),b.readUInt32BE(20)];};
const CM=37.795;
const caption=(label,txt,rest)=>{ // numbered with a SEQ field so Word can list captions
  const m=txt; return new Paragraph({style:'Caption',keepNext:rest,children:[new TextRun(label+' '),new SimpleField(`SEQ ${label} \\* ARABIC`,String(++cnt[label])),new TextRun(': '+m)]});};
const cnt={Table:0,Figure:0};
const COLS={'Success':[5,42,53],'Input':[1.9,1.4,2.4,1.5,2.7,3.45],'Output':[2.2,2.6,4,2.2,2.8],'Memory':[40,40,20],'Functional':[10,82,8],'Non-functional':[12,88]};
const SIZE={'Input':18,'Output':18};
const borders=(()=>{const b={style:BorderStyle.SINGLE,size:4,color:'000000'};return {top:b,bottom:b,left:b,right:b,insideHorizontal:b,insideVertical:b};})();
const table=(c)=>{
  const [,cap,,head,bodies]=c; const capText=text(cap[1].flatMap(b=>b.c));
  const key=Object.keys(COLS).find(k=>capText.toLowerCase().startsWith(k.toLowerCase())); if(!key)throw new Error('no widths for '+capText);
  const w=COLS[key],sum=w.reduce((a,b)=>a+b,0),cols=w.map(x=>Math.round(x/sum*TW)); cols[cols.length-1]+=TW-cols.reduce((a,b)=>a+b,0);
  const size=SIZE[key]||20;
  const rowsAll=[...head[1].map(r=>[r,true]),...bodies.flatMap(b=>[...b[2],...b[3]].map(r=>[r,false]))];
  const rows=rowsAll.map(([r,hdr],ri)=>new TableRow({tableHeader:hdr,cantSplit:true,children:r[1].map((cell,ci)=>new TableCell({width:{size:cols[ci],type:WidthType.DXA},shading:hdr?{type:ShadingType.CLEAR,fill:'E7E6E6',color:'auto'}:undefined,margins:{top:40,bottom:40,left:80,right:80},verticalAlign:VerticalAlign.TOP,
    children:(cell[4].length?cell[4]:[{t:'Plain',c:[]}]).map(b=>new Paragraph({style:'TableText',keepNext:ri<rowsAll.length-1,children:inl(b.c,{size,bold:hdr||undefined})}))}))}));
  return [caption('Table',capText,true),new Table({rows,columnWidths:cols,width:{size:TW,type:WidthType.DXA},layout:TableLayoutType.FIXED,borders}),new Paragraph({style:'AfterTable',children:[]})];
};
let lists=0;
const list=(items,ref,inst,level)=>items.flatMap(blocks=>blocks.flatMap((b,i)=>{
  if(b.t==='BulletList')return list(b.c,'bullets',inst,level+1);
  if(b.t==='OrderedList')return list(b.c[1],'numbers',++lists,level+1);
  return [new Paragraph({style:'ListText',numbering:{reference:ref,level,instance:inst},children:inl(b.c)})];}));
const MAXH={'main-flow':13.5,'display-ticket':11,'seating-map':14};
const figure=(c)=>{
  const img=c[2].flatMap(b=>b.c).find(x=>x.t==='Image'); const name=path.basename(img.c[2][0],'.png');
  const file=path.join(imgDir,name+'.png'); const [pw,ph]=pngSize(file);
  const s=Math.min(14.5*CM/pw,(MAXH[name]||17.5)*CM/ph,1.15*96/200); // images are rendered at 200 dpi; never enlarge much
  const capText=text(c[1][1].flatMap(b=>b.c));
  return [new Paragraph({alignment:AlignmentType.CENTER,keepNext:true,spacing:{before:60,after:60},children:[new ImageRun({type:'png',data:fs.readFileSync(file),transformation:{width:Math.round(pw*s),height:Math.round(ph*s)},altText:{title:capText,description:capText,name}})]}),caption('Figure',capText,false)];
};
const chapters=[];let cur=null,h2=0,h3=0;
const walk=bs=>{for(let i=0;i<bs.length;i++){const b=bs[i];switch(b.t){
  case 'Header':{const [lvl,[,cls],xs]=b.c; const t=text(xs);
    if(lvl===1){cur={title:t,n:chapters.length+1,kids:[]};chapters.push(cur);h2=h3=0;break;}
    if(cls.includes('unnumbered')){cur.kids.push(new Paragraph({style:'Minor',children:inl(xs)}));break;}
    if(lvl===2){h2++;h3=0;cur.kids.push(new Paragraph({heading:HeadingLevel.HEADING_2,children:[new TextRun(`${cur.n}.${h2}  ${t}`)]}));}
    else{h3++;cur.kids.push(new Paragraph({heading:HeadingLevel.HEADING_3,children:[new TextRun(`${cur.n}.${h2}.${h3}  ${t}`)]}));}
    break;}
  case 'Para':case 'Plain':{const next=bs[i+1];const toFig=next&&next.t==='Figure';if(!b.c.length)break;
    cur.kids.push(new Paragraph({style:'Body',keepNext:toFig,children:inl(b.c)}));break;}
  case 'BulletList':cur.kids.push(...list(b.c,'bullets',++lists,0));break;
  case 'OrderedList':cur.kids.push(...list(b.c[1],'numbers',++lists,0));break;
  case 'Table':cur.kids.push(...table(b.c));break;
  case 'Figure':cur.kids.push(...figure(b.c));break;
  case 'Div':walk(b.c[1]);break;
  case 'RawBlock':break;
  default:throw new Error('block '+b.t);}}};
walk(ast.blocks);
const cp=(t,size,o={})=>new Paragraph({alignment:AlignmentType.CENTER,spacing:{before:o.before||0,after:o.after||0,line:276},children:[new TextRun({text:t,size,bold:o.bold})]});
const [lw,lh]=pngSize(logo);const lwpx=5*CM;
const cover=[new Paragraph({alignment:AlignmentType.CENTER,spacing:{after:360},children:[new ImageRun({type:'png',data:fs.readFileSync(logo),transformation:{width:Math.round(lwpx),height:Math.round(lwpx*lh/lw)},altText:{title:'University logo',description:'Applied Science Private University logo',name:'logo'}})]}),
 cp('Cinema Ticket Reservation and Revenue Management System (CTRMS)',40,{bold:true,after:120}),cp('Phase 1: Proposal & Analysis',28,{bold:true,after:480}),
 cp('By (Group 102):',32,{after:60}),cp('Noureddin Ghazal (202511039)',32,{bold:true}),cp('Yousef Kitaneh (202311043)',32,{bold:true}),cp('Ahmad Jahaf (202310390)',32,{bold:true,after:360}),
 cp('Instructor:',32,{after:60}),cp('Dr. Khaled Al-Hashash',32,{bold:true,after:480}),
 cp('This project was submitted in Partial Fulfilment of the Requirements for the Microcomputer Systems and Assembly Language Course (1301224)',28,{after:360}),
 cp('Applied Science Private University',28),cp('Faculty of Information Technology',28,{after:240}),cp('Amman - Jordan',28),cp('November 2026',28)];
const ft=()=>new Footer({children:[new Paragraph({alignment:AlignmentType.CENTER,children:[new TextRun({children:[PageNumber.CURRENT]})]})]});
const emptyH=()=>new Header({children:[new Paragraph({children:[]})]}),emptyF=()=>new Footer({children:[new Paragraph({children:[]})]});
const margin={top:1440,bottom:1440,left:1440,right:1440};
const size={width:11906,height:16838};
const fronth=t=>new Paragraph({style:'FrontTitle',pageBreakBefore:t!=='Table of Contents',children:[new TextRun(t)]});
const sections=[
 {properties:{page:{size,margin}},headers:{default:emptyH()},footers:{default:emptyF()},children:cover},
 {properties:{type:SectionType.NEXT_PAGE,page:{size,margin,pageNumbers:{start:1,formatType:NumberFormat.LOWER_ROMAN}}},headers:{default:emptyH()},footers:{default:ft()},children:[
   fronth('Table of Contents'),new TableOfContents('Table of Contents',{hyperlink:true,headingStyleRange:'1-3'}),
   fronth('List of Tables'),new TableOfContents('List of Tables',{hyperlink:true,captionLabel:'Table'}),
   fronth('List of Figures'),new TableOfContents('List of Figures',{hyperlink:true,captionLabel:'Figure'})]},
];
chapters.forEach((c,i)=>{
 sections.push({properties:{type:SectionType.NEXT_PAGE,verticalAlign:VC.CENTER,page:{size,margin,pageNumbers:i===0?{start:1,formatType:NumberFormat.DECIMAL}:{formatType:NumberFormat.DECIMAL}}},headers:{default:emptyH()},footers:{default:emptyF()},
   children:[new Paragraph({heading:HeadingLevel.HEADING_1,children:[new TextRun(`Chapter ${WORDS[c.n]}`),new TextRun({break:1,text:c.title})]})]});
 sections.push({properties:{type:SectionType.NEXT_PAGE,page:{size,margin,pageNumbers:{formatType:NumberFormat.DECIMAL}}},
   headers:{default:new Header({children:[new Paragraph({alignment:AlignmentType.CENTER,border:{bottom:{style:BorderStyle.SINGLE,size:6,color:'000000',space:4}},children:[new TextRun({text:`Chapter ${WORDS[c.n]}: ${c.title}`,bold:true,size:22})]})]})},footers:{default:ft()},children:c.kids});
});
const lvl=(format,text,left,hang)=>({format,text,alignment:AlignmentType.LEFT,style:{paragraph:{indent:{left,hanging:hang}}}});
const doc=new Document({creator:'Group 102',lastModifiedBy:'Group 102',title:'Phase 1: Proposal & Analysis',
 styles:{default:{document:{run:{font:FONT,size:24},paragraph:{spacing:{line:300}}},
   heading1:{run:{font:FONT,size:44,bold:true,color:'000000'},paragraph:{alignment:AlignmentType.CENTER,spacing:{line:480,before:0,after:0},keepNext:true}},
   heading2:{run:{font:FONT,size:28,bold:true,color:'000000'},paragraph:{spacing:{before:300,after:120},keepNext:true}},
   heading3:{run:{font:FONT,size:24,bold:true,color:'000000'},paragraph:{spacing:{before:240,after:100},keepNext:true}}},
  paragraphStyles:[
   {id:'Body',name:'Body Paragraph',basedOn:'Normal',quickFormat:true,paragraph:{alignment:AlignmentType.JUSTIFIED,spacing:{after:120,line:300}}},
   {id:'ListText',name:'List Text',basedOn:'Normal',paragraph:{spacing:{after:80,line:288}}},
   {id:'Minor',name:'Minor Heading',basedOn:'Normal',next:'Body',run:{bold:true},paragraph:{spacing:{before:200,after:80},keepNext:true}},
   {id:'Caption',name:'Caption',basedOn:'Normal',next:'Body',run:{size:22},paragraph:{alignment:AlignmentType.CENTER,spacing:{before:120,after:120,line:240}}},
   {id:'TableText',name:'Table Text',basedOn:'Normal',paragraph:{alignment:AlignmentType.LEFT,spacing:{before:0,after:0,line:240}}},
   {id:'AfterTable',name:'After Table',basedOn:'Normal',run:{size:12},paragraph:{spacing:{before:0,after:120,line:240}}},
   {id:'TOC1',name:'toc 1',basedOn:'Normal',run:{bold:true},paragraph:{spacing:{before:100,after:20,line:252}}},
   {id:'TOC2',name:'toc 2',basedOn:'Normal',paragraph:{indent:{left:240},spacing:{after:10,line:252}}},
   {id:'TOC3',name:'toc 3',basedOn:'Normal',paragraph:{indent:{left:480},spacing:{after:10,line:252}}},
   {id:'TableofFigures',name:'table of figures',basedOn:'Normal',paragraph:{spacing:{after:60,line:264}}},
   {id:'FrontTitle',name:'Front Title',basedOn:'Normal',run:{size:40,bold:true},paragraph:{alignment:AlignmentType.CENTER,spacing:{after:360}}},
  ]},
 numbering:{config:[
  {reference:'bullets',levels:[{level:0,...lvl(LevelFormat.BULLET,'\u2022',500,250)},{level:1,...lvl(LevelFormat.BULLET,'\u2013',1000,250)}]},
  {reference:'numbers',levels:[{level:0,...lvl(LevelFormat.DECIMAL,'%1.',500,400)},{level:1,...lvl(LevelFormat.BULLET,'\u2022',1000,250)}]},
 ]},
 features:{updateFields:false},sections});
Packer.toBuffer(doc).then(b=>{fs.writeFileSync(out,b);console.log('figures',cnt.Figure,'tables',cnt.Table,'chapters',chapters.length);});
