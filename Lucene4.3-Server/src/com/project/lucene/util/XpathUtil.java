package com.project.lucene.util;

import java.io.IOException;
import java.util.Hashtable;
import java.util.Map;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import javax.xml.parsers.*;
import javax.xml.xpath.*;

public class XpathUtil {

    public String getXpathValue(Document doc, String strXpathExpression) throws ParserConfigurationException, SAXException, IOException, XPathExpressionException
    {    
        String strXpathResult = "";
        
        DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
        domFactory.setNamespaceAware(true); // never forget this!
        DocumentBuilder builder = domFactory.newDocumentBuilder();
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        XPathExpression expr = xpath.compile(strXpathExpression);
        Object result = expr.evaluate(doc, XPathConstants.NODESET);
        
        NodeList nodes = (NodeList) result;

        for (int i = 0; i < nodes.getLength(); i++) {
           strXpathResult =  nodes.item(i).getNodeValue();
        }
        
        return strXpathResult;
    }
}
