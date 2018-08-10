
/**
 * @author 庄展鹏
 * 2018-7-7
 * 创新实验室 WEB 培训选拔测试题--题2
 */
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Scanner;

public class Main {

	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		String string = input.next();
		String str[] = string.split("->");// 分割字符串

		LinkedList list = new LinkedList();
		for (int i = 0; i < str.length - 1; i++) {// 添加到链表
			list.add(str[i]);
		}
		for (int i = 1; i < (str.length - 1) / 2 + 1; i++) {// 移除偶数节点然后把他添加到链表末尾（此时NULL节点还未添加进来）
			list.add(list.remove(i));
		}
		list.add("NULL");

		Iterator it = list.iterator();// 迭代器迭代
		while (it.hasNext()) {
			System.out.print(it.next());
			if (it.hasNext())
				System.out.print("->");
		}
	}
}
