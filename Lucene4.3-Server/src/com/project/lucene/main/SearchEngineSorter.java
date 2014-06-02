package com.project.lucene.main;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.kr.KoreanAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.MatchAllDocsQuery;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.TopFieldCollector;
import org.apache.lucene.search.highlight.Fragmenter;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

import com.project.lucene.bean.LogBean;
import com.project.lucene.config.IndexConstants;
import com.project.lucene.util.Logs;

public class SearchEngineSorter {
	

	private static final String INDEX_LOCATION = "D:/LuceneTest/Index";
	
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
			//searcher.setSimilarity(getSimilarity());

			QueryParser parser = new QueryParser(Version.LUCENE_43, "year",
					analyzer);

			/*
			String searchParam = String.format(
					"(%s:\"%s\" OR %s:\"%s\") AND %s:%s",
					IndexConstants.KEY_CONTENT, querystr,
					IndexConstants.KEY_TITLE, querystr,
					IndexConstants.KEY_USERNAME, username);
		    */
			String searchParam = String.format(
					"%s:\"%s\" AND %s:%s",
					IndexConstants.KEY_YEAR, querystr,
					IndexConstants.KEY_USERNAME, username);
			
			
			System.out.println("searchparam    "+searchParam);
			
			Query query = parser.parse(searchParam);
			//Query query = new MatchAllDocsQuery(parser.parse(searchParam));
			System.out.println(query);
		
			SortField[] sortField = new SortField[] {
//					new SortField(IndexConstants.KEY_CONTENT,
//							SortField.Type.SCORE, false),
					new SortField(IndexConstants.KEY_DATE,
							SortField.Type.STRING, true),
							new SortField(IndexConstants.KEY_YEAR,
									SortField.Type.STRING, true)};
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

			System.out.println("count_Sorter: " + hits.length);

		
			int i=0;
			for (int a = 0; a < hits.length; a++) {
				// for (ScoreDoc hit : hits) {

				ScoreDoc hit;
		
				hit = hits[a];		

//				if(a!=0&&(hits[a].score==hits[a-1].score)){
//					continue;
//				}
//				else {
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
					bean.setYear(selectDoc.get(IndexConstants.KEY_YEAR));

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
				
					System.out.println("제목: "+ bean.getTitle() + " 본문내용: " + bean.getContent() + " URL: " + bean.getURL());	 
						 
					System.out.println("방문시간 : " + bean.getDate() + "  스코어 : "
							+ bean.getScore());
										i++;
//				}
			

			}
			System.out.println("출력결과Sorter : "+i);

		} catch (Exception e) {
			Logs.out.error(e, e);
		}
		return result;
	}

}
