// The file linklist.h defines the templated class LinkList.

#ifndef __LINKLIST_H__
#define __LINKLIST_H__

#include "linknode.h"

// linked list based on LinkNode
/*
   A linked list based on LinkNode
 */

template <class T>
class LinkList
{
   public:

      LinkNode<T>* link_header; // Header of the LinkList

      LinkNode<T>* link_last; // Last node of the LinkList

      int n_node; // Number of Nodes in the LinkList

      LinkList() // constructor
      /*
         Create a zero node as the header;
       */
      {
         link_header = new LinkNode<T>(0);
         link_last = link_header;
         n_node = 0;
      }
	
      LinkNode<T>* header()
      {
         return link_header->next;
      }

      void append(T new_data);
      // Append a new node with new_data
      /*
         Use LinkNode::append to creat a new node of new_data
         and append it to the NodeList. 
         Increase n_node by 1;
         /param new_data a data of T type
         /sa LinkNode::append
       */

      void print(); // prints the list
      /*
         Prints the data of the list.  The header is skipped.
       */

      void print_class(); // prints the list of a certain class
      /*
         Uses the print method in the class to print the list.
         The header is skipped.
       */

      void destroy();
      // destructor for linked list of simple data
      /*
         Deletes every node in the list.
       */

      void destroy_class();
      // destructor for linked list of certain class
      /*
         Deletes every node and its data in the list.
       */
};

#include "linklist.tpp"

#endif
