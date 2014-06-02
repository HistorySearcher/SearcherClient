package com.project.lucene.main;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.kr.KoreanAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopFieldCollector;
import org.apache.lucene.search.highlight.Encoder;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.Fragmenter;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.search.highlight.Scorer;
import org.apache.lucene.search.highlight.SimpleSpanFragmenter;
import org.apache.lucene.search.highlight.TokenSources;
import org.apache.lucene.search.similarities.DefaultSimilarity;
import org.apache.lucene.search.similarities.Similarity;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
//import org.apache.lucene.search.highlight.QueryScorer;
import org.jdom.CDATA;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.project.lucene.bean.LogBean;
import com.project.lucene.config.IndexConstants;
import com.project.lucene.util.Logs;

public class SearchEngine {

	private static final String INDEX_LOCATION = "D:/LuceneTest/Index";


	public static void index(LogBean bean) {
		Directory directory = null;
		KoreanAnalyzer analyzer = null;
		IndexWriter writer = null;
		Date start = new Date();

		try {
			File indexLocation = new File(INDEX_LOCATION);

			if (!indexLocation.exists()) {
				indexLocation.mkdir();
			}

			directory = FSDirectory.open(indexLocation);

			analyzer = new KoreanAnalyzer(Version.LUCENE_43);
			/*
			 * writer 설정생성 기존 모드에 append 하는게 아니라 CREATE 처리 하는 부분.
			 */
			IndexWriterConfig iConf = new IndexWriterConfig(Version.LUCENE_43,
					analyzer);

			// boolean create=true;
			// if(create){
			// iConf.setOpenMode(OpenMode.CREATE);
			// } else {
			// iConf.setOpenMode(OpenMode.CREATE_OR_APPEND);
			// }

			iConf.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
			iConf.setSimilarity(getSimilarity());
			// Index 폴더 안에 내용을 다 지우고 서버 시작한다면 append를 create로 바꾸고 색인을 하나 한다음
			// append로 변경
			// 만일 create 모드를 쓰고 싶으면, 분명 INDEX LOCATION안에 있는 파일을 전부 다 삭제
			// 해야 한다. 안그럼 꼬인다.

			writer = new IndexWriter(directory, iConf); // writer 사용 준비 완료

			/*
			 * Document에 입력 및 index 추가
			 */
			Document doc = new Document();
			doc.add(new TextField(IndexConstants.KEY_USERNAME, bean
					.getUserName(), Field.Store.YES));
			doc.add(new TextField(IndexConstants.KEY_URL, bean.getURL(),
					Field.Store.YES));
			doc.add(new TextField(IndexConstants.KEY_TITLE, bean.getTitle(),
					Field.Store.YES));
			doc.add(new StringField(IndexConstants.KEY_DATE, bean
					.getDate(), Field.Store.YES));
			doc.add(new TextField(IndexConstants.KEY_CONTENT,
					bean.getContent(), Field.Store.YES));
			doc.add(new TextField(IndexConstants.KEY_TIME, bean.getTime(),
					Field.Store.YES));
			writer.addDocument(doc);
			Date end = new Date();
			System.out.println(end.getTime() - start.getTime()
					+ " : totalmilliseconds");
			System.out.println("user name : "+bean.getUserName() + "  Title : "
					+ bean.getTitle());
			System.out.println("URL :  " + bean.getURL());
			System.out.println("본문 " + bean.getContent());
			System.out.println(bean.getDate());


		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			System.out.println(bean.getTime());
			try {

				if (writer != null)
					writer.close();
				if (directory != null)
					directory.close();
				if (analyzer != null)
					analyzer.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public static List<LogBean> search(String username, String querystr) {
		Directory directory = null;
		KoreanAnalyzer analyzer = null;
		DirectoryReader reader = null;
		List<LogBean> result = new ArrayList<LogBean>();
		try {
			File indexLocation = new File(INDEX_LOCATION);

			if (!indexLocation.exists()) {
				indexLocation.mkdir();
			}

			directory = FSDirectory.open(indexLocation);

			analyzer = new KoreanAnalyzer(Version.LUCENE_43);
			/*
			 * NOTE: IndexReader instances are completely thread safe, meaning
			 * multiple threads can call any of its methods, concurrently. If
			 * your application requires external synchronization, you should
			 * not synchronize on the IndexReader instance; use your own
			 * (non-Lucene) objects instead. 보통 안쓴다고 뭐라 하는데 4시리즈는 멀티스레드용이면 이게 낫다
			 * 라고 한다
			 */
			reader = DirectoryReader.open(directory);

			IndexSearcher searcher = new IndexSearcher(reader);
			searcher.setSimilarity(getSimilarity());

			QueryParser parser = new QueryParser(Version.LUCENE_43, "content",
					analyzer);

			String searchParam = String.format(
					"(%s:\"%s\" OR %s:\"%s\") AND %s:%s",
					IndexConstants.KEY_CONTENT, querystr,
					IndexConstants.KEY_TITLE, querystr,
					IndexConstants.KEY_USERNAME, username);
		
			System.out.println("searahparam          "+searchParam);
			
			Query query = parser.parse(searchParam);
			System.out.println(query);
		
					SortField[] sortField = new SortField[] {
					new SortField(IndexConstants.KEY_CONTENT,
							SortField.Type.SCORE, false),
					new SortField(IndexConstants.KEY_DATE,
							SortField.Type.STRING, true) };
			Sort sort = new Sort(sortField);

			int hitsPerPage = 1000000;
			TopFieldCollector collector = TopFieldCollector.create(sort,
					hitsPerPage, false, true, true, true);
			searcher.search(query, collector);

			ScoreDoc[] hits = collector.topDocs().scoreDocs;
			BoldFormatter formatter = new BoldFormatter();
		
			Highlighter highlighter = new Highlighter(formatter, new QueryScorer(query));
			
			Fragmenter fragmenter = new SimpleFragmenter(50);
			
			highlighter.setTextFragmenter(fragmenter);

			System.out.println("count: " + hits.length);

		
			int i=0;
			for (int a = 0; a < hits.length; a++) {
				// for (ScoreDoc hit : hits) {

				ScoreDoc hit;
		
				hit = hits[a];		

				if(a!=0&&(hits[a].score==hits[a-1].score)){
					continue;
				}
				else {
					LogBean bean = new LogBean();
					
					float score = hits[a].score;
					//위 스코어 값에다가 내가 정한 함수의 값을 곱해주자
//					System.out.println("원래 스코어"+score);
					
					int docId = hit.doc;
					Document selectDoc = searcher.doc(docId);
				
					String fragmentSeparator = "...";
					//TermPositionVector tvp = (TermPositionVector) reader.getTermVector(hits[a], "content");
					bean.setDate(selectDoc.get(IndexConstants.KEY_DATE));
					
					score=score*(Float.parseFloat(bean.getDate().substring(0, 10))/Float.parseFloat(bean.getNow()));
//					System.out.println("나중 스코어"+score);
					
					bean.setUserName(selectDoc.get(IndexConstants.KEY_USERNAME));

					// 요약된 정보를 넘겨주기
//					 bean.setContent(selectDoc.get(IndexConstants.KEY_CONTENT));
					 
					 TokenStream tokenStream = analyzer.tokenStream("", new StringReader(selectDoc.get(IndexConstants.KEY_CONTENT)));
					 try{
						 String resultContent = highlighter.getBestFragments(tokenStream, selectDoc.get(IndexConstants.KEY_CONTENT) ,3,fragmentSeparator);
						 System.out.println("highlighter   "+resultContent);
						 bean.setContent(resultContent);
					 } catch (IOException e){
						 e.printStackTrace();
					 }
			
					 
//						2			
//					 TokenStream stream = TokenSources.getAnyTokenStream(searcher.getIndexReader(), hit.doc, "content", selectDoc, analyzer);
//					 String fragment = highlighter.getBestFragments(stream, bean.getContent(),10,fragmentSeparator);
//					 System.out.println(fragment);
					 
					 
					bean.setDate(selectDoc.get(IndexConstants.KEY_TIME));
					bean.setURL(selectDoc.get(IndexConstants.KEY_URL));
					bean.setTitle(selectDoc.get(IndexConstants.KEY_TITLE));
					bean.setScore(String.valueOf(score));
					bean.setTime(selectDoc.get(IndexConstants.KEY_TIME));

					result.add(bean);
				
						 
						 
					System.out.println("방문시간 : " + bean.getDate() + "  스코어 : "
							+ bean.getScore());
										i++;
				}
			

			}
			System.out.println("출력결과 : "+i);

		} catch (Exception e) {
			Logs.out.error(e, e);
		}
		return result;
	}

	public static String toXml(List<LogBean> beans) {
		org.jdom.Document doc = new org.jdom.Document();

		Element root = new Element("Root");

		doc.setRootElement(root);
		for (LogBean bean : beans) {
			Element item = new Element("Item");

			Element urlAddress = new Element("UrlAddress");
			Element title = new Element("Title");
			Element visitingTime = new Element("VisitingTime");
			Element score = new Element("score");
			Element content = new Element("Content");

			urlAddress.setText(bean.getURL());
			title.setText(bean.getTitle());
			visitingTime.setText(bean.getDate());
			score.setText(bean.getScore());
			content.addContent(new CDATA(bean.getContent()));

			item.addContent(urlAddress);
			item.addContent(title);
			item.addContent(visitingTime);
			item.addContent(score);
			item.addContent(content);

			root.addContent(item);
		}

		OutputStream out = new ByteArrayOutputStream();
		XMLOutputter serializer = new XMLOutputter();

		Format f = serializer.getFormat();
		f.setEncoding("UTF-8");
		f.setIndent(" ");
		f.setLineSeparator("\r\n");
		f.setTextMode(Format.TextMode.TRIM);
		f.setOmitDeclaration(true);
		serializer.setFormat(f);

		String result = null;

		try {
			serializer.output(doc, out);
			result = out.toString();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	private static Similarity getSimilarity() {
		return new TestSimilarity();
	}

	private static class TestSimilarity extends DefaultSimilarity {
		public TestSimilarity() {

		}

		public float tf(float freq) {
			if (freq > 0.0f)
				return 1.0f;
			else
				return 0.0f;
		}

		public float lengthNorm(String fieldName, int numTerms) {
			return 1.0f;
		}

		public float idf(int docFreq, int numDocs) {
			return 1.0f;
		}

	}
	/*
	 * private static Query getDisMaxQuery(){ DisjunctionMaxQuery dmq1 = new
	 * DisjunctionMaxQuery( 0.1f ); dmq1.add( getTermQuery( FT, "computer" ) );
	 * dmq1.add( getTermQuery( FC, "computer" ) );
	 * 
	 * DisjunctionMaxQuery dmq2 = new DisjunctionMaxQuery( 0.1f ); dmq2.add(
	 * getTermQuery( FT, "apple" ) ); dmq2.add( getTermQuery( FC, "apple" ) );
	 * 
	 * BooleanQuery bq = new BooleanQuery(); bq.add( dmq1, Occur.SHOULD );
	 * bq.add( dmq2, Occur.SHOULD );
	 * 
	 * return bq;
	 * 
	 * }
	 */

}
