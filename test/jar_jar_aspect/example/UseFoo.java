package FooTown;
import foo.Twitter;
import foo.TwitterException;
import foo.TwitterFactory;
import foo.UserList;


// From https://github.com/Twitter4J/Twitter4J/blob/master/twitter4j-examples/src/main/java/twitter4j/examples/list/CreateUserList.java
public class UseFoo {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java twitter4j.examples.list.CreateUserList [list name] [list description]");
            System.exit(-1);
        }
        try {
            Twitter twitter = new TwitterFactory().getInstance();
            String description = null;
            if (args.length >= 2) {
                description = args[1];
            }
            UserList list = twitter.createUserList(args[0], true, description);
            System.out.println("Successfully created a list (id:" + list.getId() + ", slug:" + list.getSlug() + ").");
            System.exit(0);
        } catch (TwitterException te) {
            te.printStackTrace();
            System.out.println("Failed to create a list: " + te.getMessage());
            System.exit(-1);
        }
    }
}
