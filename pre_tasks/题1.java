
/**
 * @author 庄展鹏
 * 2018-7-7
 * 创新实验室 WEB 培训选拔测试题--题1
 */
import java.util.Scanner;

public class Main {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		String str = input.next();
		boolean flag=false;

		int ch[]=new int[26];
		
		for(int i=0;i<str.length();i++) {
			ch[str.charAt(i)-'a']++;
		}
		for(int i=0;i<str.length();i++) {
			if(ch[str.charAt(i)-'a']==1) {
				System.out.println(i);
				flag=true;
				break;
			}
		}
		if(!flag)
			System.out.println(-1);
	}
}
